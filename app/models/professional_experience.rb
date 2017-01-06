class ProfessionalExperience < ActiveRecord::Base
	belongs_to :company
	attr_accessor :tmp_professionalexperience
	accepts_nested_attributes_for :company   

end
