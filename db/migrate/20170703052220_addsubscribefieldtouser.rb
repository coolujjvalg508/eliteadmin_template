class Addsubscribefieldtouser < ActiveRecord::Migration
  def change
  	add_column :users, :is_subscribed, :boolean, :default => false
  	add_column :users, :subscription_end_date, :string
  end
end
