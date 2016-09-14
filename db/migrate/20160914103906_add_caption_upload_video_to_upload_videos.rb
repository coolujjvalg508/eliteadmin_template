class AddCaptionUploadVideoToUploadVideos < ActiveRecord::Migration
  def change
  add_column :upload_videos, :caption_upload_video, :string
  end
end
