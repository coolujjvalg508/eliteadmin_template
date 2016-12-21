class NewsletterSetting < ActiveRecord::Base
	#enum email_digest_option: { Daily: 'D', Weekly: 'W', Monthly: 'M'}
	validates :email_digest_option, presence: true
end
