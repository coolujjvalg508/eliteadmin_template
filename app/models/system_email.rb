class SystemEmail < ActiveRecord::Base
	enum status: { inactive: 0, active: 1}
	validates :title, presence: true
	validates :content, presence: true

	############## Call Backs ###########################
  after_initialize :next_identifier, unless: :persisted?

  def next_identifier
    e = SystemEmail.last
    self.identifier = e.nil? ? 'MAIL-001' : e.identifier.to_s.succ
  end
end
