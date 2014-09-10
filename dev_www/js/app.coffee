$ = require 'jquery-browserify'
Contact = require './Contact'
require 'slick-carousel'

class App
	constructor : () ->
		@$window = $(window)
		@$navPrimary = $('#nav-primary')
		@$headerWrapper = $('#header-wrapper')
		@$body = $('body')

		@$headerWrapper.remove().appendTo('body')

		@attachEvents()

		if window.siteSettings?
			if window.siteSettings.page is 'contact'
				$('#nav-contact').addClass 'active'
				new Contact()

			if window.siteSettings.page is 'project'
				$('#nav-projects').addClass 'active'
				# @initSlick()

			if window.siteSettings.page is 'projects'
				$('#nav-projects').addClass 'active'

			if window.siteSettings.page is 'about'
				$('#nav-about').addClass 'active'

			if window.siteSettings.page is 'vision'
				$('#nav-vision').addClass 'active'

			if window.siteSettings.page is 'process'
				$('#nav-process').addClass 'active'


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


	initSlick : () ->
		$('#carousel-feature').slick
			slidesToShow: 1
			slidesToScroll: 1
			arrows: false
			fade: true
			asNavFor: '#carousel-nav'

		$('#carousel-nav').slick
			slidesToShow: 3
			slidesToScroll: 1
			asNavFor: '#carousel-feature'
			dots: true
			centerMode: true
			focusOnSelect: true


$ ->
	window.NickStevens = new App()