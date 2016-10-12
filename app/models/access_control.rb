class AccessControl < ActiveRecord::Base
	serialize :permissions, Hash

	belongs_to :user_group
	attr_accessor :permissions_hash

	def permissions_hash
		array = []
		if permissions
		
			permissions.each do |x,y|
		    y.each do |z|
		      array << x+'_'+z
		    end
			end
		end
		return array
	end

	def permissions_hash=(values)
		custom_hash = {}
		values.uniq.each do |value|
	    if value.length > 1
		    c = value.split('_')
		    custom_hash[c[0]] ||= []
	    	custom_hash[c[0]] << c[1]
	    	# If either WRITE or DELETE access is given then there should be default READ access
	    	custom_hash[c[0]] << 'read' if ['write', 'delete'].include?(c[1]) && !custom_hash[c[0]].include?('read')
	    end
		end
		
		self.permissions = custom_hash
	end
	belongs_to :admin_user
end
