ActiveAdmin.register NewsletterSubscriber do

	menu label: 'Newsletter'
	permit_params :email
	form multipart: true do |f|
		f.inputs "Newsletter Subscribers" do
			f.input :email
		end

		f.actions
	end

end
