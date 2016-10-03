class AddCompanyIdToProfessionalExperience < ActiveRecord::Migration
  def change
  add_column :professional_experiences, :company_id, :integer
  end
end
