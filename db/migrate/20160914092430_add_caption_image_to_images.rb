class AddCaptionImageToImages < ActiveRecord::Migration
  def change
  add_column :images, :caption_image, :string
  end
end
