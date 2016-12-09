class User < ActiveRecord::Base

  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable, :confirmable


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
   
  ############################ Constants ################################
  PROFILE_TYPE = ["Artist", "Recruiter", "Studio"]
  ########################### Validations ################################
         
         
         
end
