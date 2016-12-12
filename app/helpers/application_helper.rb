module ApplicationHelper
	#The below method is for display error messages next to field (ActiveModel validation messages)
	def form_error_msg_for(model_obj, field_name, field_name_as=nil)
		begin
			field_name_as ||= field_name
			if model_obj.errors.present? && model_obj.errors[field_name.to_sym].present?
				"<div class='error-msg'>#{field_name_as.to_s.humanize+' '+model_obj.errors.messages[field_name.to_sym].first}</div>".html_safe
			end
		rescue Exception => e
			""
		end
	end

	def error_message(object, field)
		if object.errors.present? && object.errors.messages.present?
			if object.is_a?(User) && object.errors.messages[field.to_sym].present?
				if field.to_s == "email" && object.errors.messages[field.to_sym].include?("Email can't be blank")
					err_msg = "<div class='error-msg'>Email can't be blank</div>"
					return err_msg.html_safe
				elsif field.to_s == "email" && object.errors.messages[field.to_sym].include?("Please enter a valid email")
					err_msg = "<div class='error-msg'>Please enter a valid email</div>"
					return err_msg.html_safe
				elsif field.to_s == "email" && object.errors.messages[field.to_sym].include?("has already been taken")
					err_msg = "<div class='error-msg'>Email has already been taken</div>"
					return err_msg.html_safe
				elsif field.to_s == "email" && object.errors.messages[field.to_sym].include?("not found")
				err_msg = "<div class='error-msg'>Email not found</div>"
				return err_msg.html_safe
				elsif field.to_s == "email_confirmation" && object.errors.messages[field.to_sym].include?("doesn't match Email")
					err_msg = "<div class='error-msg'>Email confirmation doesn't match</div>"
					return err_msg.html_safe
				elsif field.to_s == "password" && object.errors.messages[field.to_sym].include?("can't be blank")
					err_msg = "<div class='error-msg'>Password can't be blank</div>"
					return err_msg.html_safe
				elsif field.to_s == "password" && object.errors.messages[field.to_sym].include?("is too short (minimum is 6 characters)")
					err_msg = "<div class='error-msg'>Password can't be less then 6 characters</div>"
					return err_msg.html_safe
				elsif field.to_s == "password_confirmation" && object.errors.messages[field.to_sym].include?("doesn't match Password")
					err_msg = "<div class='error-msg'>Password confirmation doesn't match</div>"
					return err_msg.html_safe
				else
					err_msg = "<div class='error-msg'>" + object.errors.messages[field.to_sym].try(:first).to_s + "</div>"
					return err_msg.html_safe
				end
			else
				err_msg = "<div class='error-msg'>" + object.errors.messages[field.to_sym].try(:first).to_s + "</div>"
				return err_msg.html_safe
			end
		else
			return nil
		end
	end

	
	def format_time(time)
		begin
			time.strftime("%m/%d/%Y %I:%M%p")
		rescue Exception => e
			""
		end
	end

	def format_date(date)
		begin
			date.strftime("%m/%d/%Y")
		rescue Exception => e
			""
		end
	end

	## Mailboxer conversations
	def has_attachment?(conversation)
		return false unless conversation.is_a?(Mailboxer::Conversation)
    status = false
    conversation.messages.each do |message|
      if message.attachment?
        status = true
        break
      end
    end
    return status    
	end

	def last_message_from(conversation,user)		
		return "" unless conversation.is_a?(Mailboxer::Conversation)
		receipt = conversation.receipts.sentbox.where.not(receiver_type: user.class.name, receiver_id: user.try(:id)).last
		receipt.try(:receiver).try(:name).to_s
	end

	def last_message_to(conversation,user)		
		return "" unless conversation.is_a?(Mailboxer::Conversation)
		receipt = conversation.receipts.inbox.where.not(receiver_type: user.class.name,receiver_id: user.try(:id)).last
		receipt.try(:receiver).try(:name).to_s
	end

	#Active admin helper methods
	def message_time_format(time)
		begin
			time.in_time_zone("Mumbai").strftime("%m/%d/%Y %I:%M%p")
		rescue Exception => e
			""
		end
	end

	def asset_data_base64(path)
	  asset = Rails.application.assets.find_asset(path)
	  throw "Could not find asset '#{path}'" if asset.nil?
	  base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
	  "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
	end
	
	def resource_name
		:user
	end

	def resource
		@resource ||= User.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end

	def get_random_one_questionaire
		Questionaire.order('random()').first
	end

end

