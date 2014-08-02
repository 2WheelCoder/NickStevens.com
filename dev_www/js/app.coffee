$ = require 'jquery'
Contact = require './Contact'
# stroll = require './vendor/stroll.min.js'

class App
	constructor : () ->
		@$window = $(window)
		@$navPrimary = $('#nav-primary')
		@$headerWrapper = $('#header-wrapper')
		@$body = $('body')
		@attachEvents()

		if window.siteSettings? and window.siteSettings.page is 'contact'
			new Contact()

	attachEvents : () =>
		self = @

		if @$window.width() >= 769
			@$window.on 'scroll touchmove', ->
				if self.$window.scrollTop() > 0
					self.$headerWrapper.addClass('compact')
					self.$body.css 'padding-top', '4rem'
				else
					self.$headerWrapper.removeClass('compact')
					self.$body.css 'padding-top', '5rem'
					

		if @$window.width() < 481
			$('#header-menu-btn').click ->
				self.$navPrimary.slideToggle()

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