class User < ActiveRecord::Base
  
  mount_uploader :image, ImageUploader
  mount_uploader :cover_art_image, CoverArtUploader

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/


  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  belongs_to  :country
  ############################ Associations #############################
  has_many :professional_experiences     
  has_many :education_experiences     
  has_many :production_experiences
  
  accepts_nested_attributes_for :professional_experiences, reject_if: proc { |attributes| attributes['company_id'].blank? || attributes['company_id'].nil? }, allow_destroy: true 
  accepts_nested_attributes_for :education_experiences, reject_if: proc { |attributes| attributes['school_name'].blank? || attributes['school_name'].nil? }, allow_destroy: true 
  accepts_nested_attributes_for :production_experiences, reject_if: proc { |attributes| attributes['production_title'].blank? || attributes['production_title'].nil? }, allow_destroy: true 
  
  ########################### Validations ################################

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :username, presence: true
  validates :username, uniqueness: {message: 'This username is already registered with us.'}
  validates :email, confirmation: true
  validates :email, presence: {message: "Email can't be blank"}
  validates :email, length: { maximum: 35, message: "Please enter no more than 35 characters." }
  validates :email, uniqueness: {message: 'This email is already registered with us.'}
  validates_format_of :email, :with  => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, :message => 'Please enter a valid email'
  validates :password, presence: {message: "Password can't be blank"}, on: :create
  validates :profile_type, presence: {message: "Please select profile type"}, on: :create
   
 validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  ############################ Constants ################################
  PROFILE_TYPE = ["Artist", "Recruiter", "Studio"]
  ########################### Validations ################################
         
  def devise_mailer
    UserMailer
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        abort(auth.to_json)
        /user = User.new(
          firstname: auth.extra.raw_info.name,
          lastname: auth.extra.raw_info.name,
          username: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save! /
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
         
end
