class AddIdentifierToSystemEmails < ActiveRecord::Migration
  def change
  	add_column :system_emails, :identifier, :string, :unique => true
  end
end
