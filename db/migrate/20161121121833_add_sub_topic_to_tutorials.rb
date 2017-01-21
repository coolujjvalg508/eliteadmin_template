class AddSubTopicToTutorials < ActiveRecord::Migration
  def change
  add_column :tutorials, :sub_topic, :json
  end
end
