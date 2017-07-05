class Addwidgetfollowingtowidget < ActiveRecord::Migration
  def change
  		add_column :widgets, :show_on_followers_page, :boolean
	  add_column :widgets, :show_on_followings_page, :boolean
  end
end
