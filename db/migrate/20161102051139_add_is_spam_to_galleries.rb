class AddIsSpamToGalleries < ActiveRecord::Migration
  def change
   add_column :galleries, :is_spam, :boolean, :default => false
  end
end
