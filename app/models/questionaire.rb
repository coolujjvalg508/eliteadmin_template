class Questionaire < ActiveRecord::Base
validates :question, :answer, presence: true
end
