class PagesController < ApplicationController

	def show
		
		@pagecontent = StaticPage.find_by(page_url: params[:page_url])
		
	end

	def faq
		@faq_data = Faq.all
		#abort(@faq_data.to_json)
	end


	def contact
		@sitesetting_data = SiteSetting.first
	end

	def post_contact
			  contactname   	 = params[:contact_data][:contactname];
		      contactemail  	 = params[:contact_data][:contactemail];
		      contactsubject	 = params[:contact_data][:contactsubject];
		      contactmessage 	 = params[:contact_data][:contactmessage];
		      to_email 	 		 = params[:contact_data][:to_email];
			  
			 UserMailer.send_contact_mail(contactname, contactemail, contactsubject, contactmessage, to_email).deliver_later
			 render :json => {'res' => 1, 'message' => "success"}, status: 200

	end	

end
