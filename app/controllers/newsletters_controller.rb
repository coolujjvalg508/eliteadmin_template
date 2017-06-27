class NewslettersController < ApplicationController
	skip_before_action :verify_authenticity_token


	def insert_email
		news_sub = NewsletterSubscriber.new(newsletter_params)
		if news_sub.save	
			render :json => {'res' => 1, 'message' => "success"}, status: 200
		else
			render :json => {'res' => 0, 'message' => "failure"}, status: 500
		end
	end

	def newsletter_params
		params.require(:newsletter_subscriber).permit(:email)
	end

end
