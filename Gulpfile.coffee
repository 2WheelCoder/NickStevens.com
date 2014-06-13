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

gulp.task 'html', ->
	return gulp.src 'dev_www/jade/**/*.jade'
		.pipe plumber()
		.pipe jade()
		.pipe gulp.dest 'local_www/'
	    .pipe gulp.dest 'build_www/'

gulp.task 'scripts', ->
	gulp.src 'dev_www/js/vendor/**/*.js'
		.pipe gulp.dest 'local_www/js/vendor/'

	return gulp.src 'dev_www/js/app.coffee', { read: false }
		.pipe plumber()
		.pipe browserify { transform: ['coffeeify'], extensions: ['.coffee'] }
		.pipe rename 'scripts.js'
	    .pipe gulp.dest 'local_www/js/'

gulp.task 'css', ->
	return gulp.src 'dev_www/css/styles.styl'
		.pipe plumber()
		.pipe stylus { use : [nib(), jeet()] }
		.pipe gulp.dest 'local_www/css/'

gulp.task 'templates', shell.task 'jaden -t dev_www/templates -d local_www/js/templates.js -p .jade -b'

gulp.task 'images', ->
	return gulp.src 'dev_www/img/**/*.{png,jpg,jpeg,gif,svg}'
		.pipe plumber()
		.pipe changed 'dev_www/img/**/*.{png,jpg,jpeg,gif,svg}'
	    .pipe imagemin()
	    .pipe gulp.dest 'local_www/img/'
	    .pipe gulp.dest 'build_www/img/'

# gulp.task 'icons', ->
# 	return gulp.src 'dev_www/icons/**/*.svg'
# 		.pipe iconfont {fontName: 'icons', appendCodepoints: true }
# 		.on 'codepoints', (codepoints, options) ->
# 	        console.log codepoints, options
# 		.pipe gulp.dest 'local_www/fonts/'

gulp.task 'build', ->
	gulp.src 'local_www/js/scripts.js'
		.pipe plumber()
	    .pipe jsmin()
	    .pipe rename {suffix: '.min'}
	    .pipe gulp.dest 'build_www/js/'
	    
	gulp.src 'local_www/css/styles.css'
		.pipe cssmin()
		.pipe rename {suffix: '.min'}
		.pipe gulp.dest 'build_www/css/'

gulp.task 'default', ['scripts', 'css'], ->
	gulp.watch 'dev_www/jade/**/*.jade', ['html']
	gulp.watch 'dev_www/templates/**/*.jade', ['templates']
	gulp.watch 'dev_www/css/**/*.styl', ['css']
	gulp.watch 'dev_www/js/**/*.coffee', ['scripts']
	gulp.watch 'dev_www/img/**/*.{png,jpg,jpeg,gif,svg}', ['images']
	# gulp.watch 'dev_www/icons/**/*.svg', ['icons']