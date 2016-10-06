class User < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  validates :group_id, presence: true
  validates :firstname, presence: true
  validates :email, presence: {message: "Email can't be blank"}
  validates :email, uniqueness: {message: 'This email is already registered with us.'}
  validates_format_of :email, :with  => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, :message => 'Please enter a valid email'

  validates :password, presence: {message: "Password can't be blank"}, on: :create
  validates :password_confirmation, presence: {message: "Password confirmation can't be blank"}, on: :create       

  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable
         
  
         
  has_many :professional_experiences     
  has_many :education_experiences     
  has_many :production_experiences     
  
  accepts_nested_attributes_for :professional_experiences, reject_if: proc { |attributes| attributes['company_id'].blank? || attributes['company_id'].nil? }, allow_destroy: true 
  accepts_nested_attributes_for :education_experiences, reject_if: proc { |attributes| attributes['school_name'].blank? || attributes['school_name'].nil? }, allow_destroy: true 
  accepts_nested_attributes_for :production_experiences, reject_if: proc { |attributes| attributes['production_title'].blank? || attributes['production_title'].nil? }, allow_destroy: true 
  
         
         
end
