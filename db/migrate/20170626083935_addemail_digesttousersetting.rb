class AddemailDigesttousersetting < ActiveRecord::Migration
  def change
  	add_column :user_settings, :email_digest_interval, :integer
  end
end
