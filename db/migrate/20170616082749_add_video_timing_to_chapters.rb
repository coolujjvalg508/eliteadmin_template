class AddVideoTimingToChapters < ActiveRecord::Migration
  def change
  	add_column :chapters, :video_timing, :string
  end
end
