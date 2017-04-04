class ReportsController < ApplicationController

	def index

	end
	
	def new
		#abort(params.to_json)	
		post_id				=	params[:report][:post_id]
		report_issue		=	params[:report][:report_issue]
		description			=	params[:report][:description]
		user_id				=	current_user.id
		post_type			=	params[:report][:post_type] 

		Report.create(post_id: post_id, report_issue: report_issue, description: description, user_id: user_id, post_type: post_type)
 		result = {'res' => 1, 'message' => 'Thank you for reporting this'}
 		#flash[:notice] = 'Thank you for reporting this.'
		render json: result, status: 200
	end	
end
