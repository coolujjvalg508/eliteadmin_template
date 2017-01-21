class AddPostTypeInDownloads < ActiveRecord::Migration
  def change
  add_column :downloads, :post_type_id, :json
  end
end
