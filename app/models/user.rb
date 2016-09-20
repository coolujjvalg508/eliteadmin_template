class User < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  validates :firstname, presence: true
  validates :email, presence: true
  
  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
         
  has_many :professional_experiences     
  has_many :education_experiences     
  has_many :production_experiences     
  accepts_nested_attributes_for :professional_experiences, reject_if: proc { |attributes| attributes['company_name'].blank? || attributes['company_name'].nil? }, allow_destroy: true 
  accepts_nested_attributes_for :education_experiences, reject_if: proc { |attributes| attributes['school_name'].blank? || attributes['school_name'].nil? }, allow_destroy: true 
  accepts_nested_attributes_for :production_experiences, reject_if: proc { |attributes| attributes['production_title'].blank? || attributes['production_title'].nil? }, allow_destroy: true 
         
         
         
end
