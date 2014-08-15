gulp = require 'gulp'
plumber = require 'gulp-plumber'
browserify = require 'gulp-browserify'
changed = require 'gulp-changed'
imagemin = require 'gulp-imagemin'
gutil = require 'gulp-util'
stylus = require 'gulp-stylus'
nib = require 'nib'
jeet = require 'jeet'
cssmin = require 'gulp-cssmin'
rename = require 'gulp-rename'
jsmin = require 'gulp-jsmin'
shell = require 'gulp-shell'
jade = require 'gulp-jade'
iconfont = require 'gulp-iconfont'
refresh = require 'gulp-livereload'
lrserver = require('tiny-lr')()
express = require 'express'
livereload = require 'connect-livereload'
marked = require 'marked'
s3 = require 'gulp-s3'
gzip = require 'gulp-gzip'
fs = require 'fs'

livereloadport = 35729
serverport = 3000
options =
	gzippedOnly : true
aws = JSON.parse(fs.readFileSync('./aws.json'))
 
# We only configure the server here and start it only when running the watch task
server = express()
# Add livereload middleware before static-middleware
server.use livereload({
	port: livereloadport
})

server.use(express.static('./local_www'))

gulp.task 'html', ->
	gulp.src ['dev_www/jade/**/*.jade', '!dev_www/jade/includes/**/*']
		.pipe plumber()
		.pipe jade()
		.pipe gulp.dest 'local_www/'
		.pipe refresh(lrserver)

gulp.task 'scripts', ->
	gulp.src 'dev_www/js/vendor/**/*.js'
		.pipe gulp.dest 'local_www/js/vendor/'

	gulp.src 'dev_www/js/app.coffee', { read: false }
		.pipe plumber()
		.pipe browserify { transform: ['coffeeify'], extensions: ['.coffee'] }
		.pipe rename 'scripts.js'
		.pipe gulp.dest 'local_www/js/'
		.pipe refresh(lrserver)

gulp.task 'css', ->
	gulp.src 'dev_www/css/styles.styl'
		.pipe plumber()
		.pipe stylus { use : [nib(), jeet()] }
		.pipe gulp.dest 'local_www/css/'
		.pipe refresh(lrserver)

gulp.task 'fonts', ->
	gulp.src 'dev_www/fonts/**/*'
		.pipe gulp.dest 'local_www/fonts/'

gulp.task 'templates', ->
	shell.task 'jaden -t dev_www/templates -d local_www/js/templates.js -p .jade -b'
	.pipe refresh(lrserver)	

gulp.task 'images', ->
	gulp.src 'dev_www/img/**/*'
		# .pipe changed 'dev_www/img/**/*'
		.pipe gulp.dest 'local_www/img/'
		.pipe refresh(lrserver)

gulp.task 'documents', ->
	gulp.src 'dev_www/documents/**/*'
		.pipe gulp.dest 'local_www/documents/'

gulp.task 'icons', ->
	gulp.src 'dev_www/icons/**/*.svg'
		.pipe iconfont {fontName: 'icons', appendCodepoints: true, normalize: true }
		.on 'codepoints', (codepoints, options) ->
	        console.log codepoints, options
		.pipe gulp.dest 'local_www/fonts/'

gulp.task 'serve', ->
	# Set up your static fileserver, which serves files in the build dir
	server.listen serverport

	# Set up your livereload server
	# lrserver.listen lrport

gulp.task 'deploy', ->
	gulp.src 'local_www/js/scripts.js'
		.pipe jsmin()
		.pipe gzip()
		.pipe gulp.dest 'build_www/js'
		.pipe s3(aws, options)
		
	gulp.src 'local_www/css/styles.css'
		.pipe cssmin()
		.pipe gzip()
		.pipe gulp.dest 'build_www/css'
		.pipe s3(aws, options)

	gulp.src 'local_www/fonts/**/*'
		.pipe gzip()
		.pipe gulp.dest 'build_www/fonts'
		.pipe s3(aws, options)

	gulp.src 'local_www/**/*.html'
		.pipe gzip()
		.pipe gulp.dest 'build_www'
		.pipe s3(aws, options)

	gulp.src 'local_www/documents/**/*'
		.pipe gzip()
		.pipe gulp.dest 'build_www/documents'
		.pipe s3(aws, options)

	gulp.src 'dev_www/img/**/*'
		.pipe imagemin()
		.pipe gzip()
		.pipe gulp.dest 'build_www/img'
		.pipe s3(aws, options)

gulp.task 'default', ['scripts', 'css', 'serve'], ->
	gulp.watch 'dev_www/jade/**/*.jade', ['html']
	gulp.watch 'dev_www/templates/**/*.jade', ['templates']
	gulp.watch 'dev_www/css/**/*.styl', ['css']
	gulp.watch 'dev_www/fonts/**/*', ['fonts']
	gulp.watch 'dev_www/js/**/*.coffee', ['scripts']
	gulp.watch 'dev_www/img/**/*.{png,jpg,jpeg,gif,svg}', ['images']
	gulp.watch 'dev_www/documents/**/*', ['documents']