$ = require 'jquery'

class Contact
	constructor : () ->
		# Initialize Parse with your Parse application & javascript keys
		Parse.initialize("9we6SeKGiuWtpiEHQDfsX6fgK72DwPKHhu4DYPH0", "4SoupCRsuS7a7ETRNZ5t5uV49Q4xj1FjSlPpwQQG")
		
		@attachEvents()

	attachEvents : () =>
		self = @

		# Setup the form to watch for the submit event
		$('#form-contact').submit (e) ->	
			e.preventDefault()

			# Grab the elements from the form to make up
			# an object containing name, email and message
			data =
				name: document.getElementById('name').value, 
				email: document.getElementById('email').value,
				phone: document.getElementById('phone').value,
				message: document.getElementById('message').value

			# Run our Parse Cloud Code and 
			# pass our 'data' object to it
			Parse.Cloud.run "sendEmail", data, {
				success: (object) ->
					$('#response').html('Email sent!').addClass('success').fadeIn('fast')
				,
				error: (object, error) ->
					console.log error
					$('#response').html('Error! Email not sent!').addClass('error').fadeIn('fast')
			}

module.exports = Contact