class AddCaptionVideoToVideos < ActiveRecord::Migration
  def change
  add_column :videos, :caption_video, :string
  end
end
