$ = require 'jquery'

class App
	$document: $(document)
	$window: $(window)

	constructor : () ->
		@attachEvents()

	attachEvents : () =>
		@$window.on 'load', () ->

		@$document.ready () =>

$ ->
	window.NickStevens = new App()