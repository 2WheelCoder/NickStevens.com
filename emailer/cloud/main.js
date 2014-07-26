Parse.Cloud.define("sendEmail", function(request, response) {
	var Mandrill = require("mandrill");
	Mandrill.initialize('rhjcPH4pxD6K-0En7hU9Ug');

	var name = request.params.name;
	var email = request.params.email;
	var phone = request.params.phone;
	var message = request.params.message;

	var text = "Name: "+name+"\nEmail: "+email+"\nPhone: "+phone+"\nMessage:\n\n"+message
 
	Mandrill.sendEmail({
		message: {
			text: text,
			subject: "New Contact Form Submission from NickStevens.com",
			from_email: "parse@cloudcode.com",
			from_name: "Cloud Code",
			to: [
				{
					email: "nick@nickstevens.com",
					name: "Nick Stevens"
				}
			]
		},
		async: true
	},{
		success: function(httpResponse) {
			console.log(httpResponse);
			response.success("Email sent!");
		},
		error: function(httpResponse) {
			console.error(httpResponse);
			response.error("Uh oh, something went wrong");
		}
	});  
});