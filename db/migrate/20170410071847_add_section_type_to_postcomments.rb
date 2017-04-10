class AddSectionTypeToPostcomments < ActiveRecord::Migration
  def change
  	add_column :post_comments, :section_type, :string
  end
end
