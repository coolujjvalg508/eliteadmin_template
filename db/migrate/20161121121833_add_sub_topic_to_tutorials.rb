class AddSubTopicToTutorials < ActiveRecord::Migration
  def change
  add_column :tutorial, :sub_topic, :json
  end
end
