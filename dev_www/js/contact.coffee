$ = require 'jquery'

class Contact
	constructor : () ->
		console.log 'contact init'

		@attachEvents()

	attachEvents : () =>
		self = @

module.exports = Contact