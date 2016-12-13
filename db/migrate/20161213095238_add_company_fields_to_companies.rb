class AddCompanyFieldsToCompanies < ActiveRecord::Migration
  def change
	add_column :companies, :user_id, :integer
	add_column :companies, :email, :string
  end
end
