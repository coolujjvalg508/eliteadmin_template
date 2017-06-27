class PagesController < ApplicationController

	def show
		
		@pagecontent = StaticPage.find_by(page_url: params[:page_url])
		
	end

	def faq
		@faq_data = Faq.all
		#abort(@faq_data.to_json)
	end

	

end
