class AddTopicForToTopics < ActiveRecord::Migration
  def change
	add_column :topics, :topic_for, :integer, default: 0
  end
end
