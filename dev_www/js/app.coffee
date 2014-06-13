$ = require 'jquery'
# stroll = require './vendor/stroll.min.js'

class App
	$document: $(document)
	$window: $(window)

	constructor : () ->
		@attachEvents()

	attachEvents : () =>
		@$window.on 'load', () ->

		@$document.ready () =>
			# windowHeight = $(window).height()
			# console.log windowHeight
			# headerHeight = $('.header-wrapper').height()
			# console.log headerHeight
			# height = windowHeight - headerHeight
			# console.log height
			# $('section.content ul').height height
			# stroll.bind 'section.content ul'

$ ->
	window.NickStevens = new App()