class Sketchfeb < ActiveRecord::Base
	attr_accessor :tmp_sketchfeb
	belongs_to :sketchfebable, polymorphic: false 
end
