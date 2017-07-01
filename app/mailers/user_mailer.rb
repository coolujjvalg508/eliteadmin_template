class UserMailer < Devise::Mailer
  helper ApplicationHelper
  default from: "CGmeetup <#{ ENV['DEFAULT_FROM_EMAIL'] }>"
  layout 'mailer'
  #before_filter :add_inline_attachment!

  def confirmation_instructions(record, token, opts={}) 
    #abort(record.to_json)
    @system_email = SystemEmail.find_by(title: 'Registration email to user when registered through registration.')
    @subject =  @system_email.try(:subject).to_s
    @subject = "Welcome to CGmeetup" if @subject.blank?

    opts = {subject: @subject}
    @token = token
    devise_mail(record, :confirmation_instructions, opts)
  end

   def reset_password_instructions(record, token, opts={})
  	@system_email = SystemEmail.find_by(title: 'Forgot password email to user received when submitted email from forgot password.')
    @subject =  @system_email.try(:subject).to_s
    @subject = "Password Reset Request" if @subject.blank?

    opts = {subject: @subject}

    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def password_change(record, opts={})
    devise_mail(record, :password_change, opts)
  end

  def job_application_email(sender_email,receiver_email,job_title,current_user)
      
      @senderemail    = sender_email
      @receiveremail  = receiver_email
      @current_user   = current_user
      @job_title      = job_title
      subject         = 'Apply for' + job_title
      #abort(@vendor_request.email.to_json)
      #abort(receiver_email.to_json)
      mail( :to => @receiveremail, :from => @senderemail, :subject => subject)
  end

  def send_contact_mail(contactname,contactemail,contactsubject,contactmessage,to_email)
      
      @contactname           = contactname
      @contactemail          = contactemail
      @contactsubject        = contactsubject
      @contactmessage        = contactmessage

      mail( :to => to_email, :from => @contactemail, :subject => @contactsubject)
  end

  private

   def add_inline_attachment!
    attachments.inline["logo.jpg"] = File.read(Rails.root.join('app/assets/images/logo.jpg'))
		attachments.inline["banner-bg.jpg"] = File.read(Rails.root.join('app/assets/images/banner-bg.jpg'))
		attachments.inline["fb.png"] = File.read(Rails.root.join('app/assets/images/fb.png'))
		attachments.inline["twt.png"] = File.read(Rails.root.join('app/assets/images/twt.png'))
		attachments.inline["in.png"] = File.read(Rails.root.join('app/assets/images/in.png'))
		attachments.inline["gl.png"] = File.read(Rails.root.join('app/assets/images/gl.png'))
		attachments.inline["yt.png"] = File.read(Rails.root.join('app/assets/images/yt.png'))
  end 

  

end
