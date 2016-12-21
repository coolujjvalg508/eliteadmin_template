class Faq < ActiveRecord::Base
    include Bootsy::Container
	validates :question, :answer, presence: true
	default_scope { order('position ASC') }
end
