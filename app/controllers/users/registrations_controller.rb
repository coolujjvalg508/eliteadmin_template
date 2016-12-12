class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource({})
    #resource.build_profile
    respond_with self.resource
  end

  # POST /resource
  def create

    build_resource(sign_up_params)

    #abort(params['q_id'].to_json)

    #["vfx1","vfx2","vfx3"]
    question_data = Questionaire.where('questionaires.id = ?', params['q_id']).first
    answer_data = question_data[:answer]
    answer_arr = answer_data.split(",")

    captcha_value = params['g-recaptcha-response']

    secret_key    = "#{Rails.application.secrets.recaptcha_secret_key}"  
    status = `curl 'https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{captcha_value}'`

    hash = JSON.parse(status)  

    #abort(hash['success'].to_json)
    #abort(hash.to_json)
    #hash['success'] == true ? true : false

    /if hash['success'] == true
      super
    else
      @captcha_error = "Please enter correct captcha"
      render action: 'new'
    end/

    @captcha_error = ''
    @question_error = ''

    if !answer_arr.include?(params['answer'])
       @question_error = 'Please enter correct answer'
    end

    if hash['success'] == false
      @captcha_error = 'Please enter correct captcha'
    end  

    if @captcha_error == '' && @question_error == ''
       super 
    else
      render action: 'new'
    end  

  end

  def verify_google_recptcha(secret_key,response)
    status = `curl “https://www.google.com/recaptcha/api/siteverify? secret=#{secret_key}&response=#{response}”`  
    hash = JSON.parse(status)
    hash[“success”] == true ? true : false
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
    # super(resource)
  end
end
