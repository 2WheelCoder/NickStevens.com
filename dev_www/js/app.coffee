$ = require 'jquery'
Contact = require './Contact'
# stroll = require './vendor/stroll.min.js'

class App
	constructor : () ->
		@$window = $(window)
		@$navPrimary = $('#nav-primary')
		# @$headerWrapper = $('#header-wrapper')
		@$body = $('body')
		@attachEvents()
		# @$primaryContent = $('#primary-content')

		# @$primaryContent.find('.nav-' + window.siteSettings.page).hide()

		# @$primaryContent
		# 	.children('.nav-contact')
		# 	.last()
		# 	.nextAll()
		# 	.remove()
		# 	.appendTo('#secondary-content')

		if window.siteSettings? and window.siteSettings.page is 'contact'
			new Contact()

		# @$headerWrapper.remove().appendTo('body')

	attachEvents : () =>
		self = @

		if window.innerWidth >= 886
			@$window.on 'scroll touchmove', ->
				if self.$window.scrollTop() > 0
					self.$body.addClass 'compact'
				else
					self.$body.removeClass 'compact'

		if window.innerWidth < 481
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