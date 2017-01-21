class AddSubTopicToNews < ActiveRecord::Migration
  def change
  add_column :news, :sub_topic, :json
  end
end
