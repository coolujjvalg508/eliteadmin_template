class Country < ActiveRecord::Base
	enum status: {inactive: 0, active: 1}
end
