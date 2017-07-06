class FeedsController < ApplicationController
  
  def rss
    @posts = Gallery.where("visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('id DESC').limit(8)
    @jobs = Job.where("is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(6)
    @downloads = Download.where("visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
    @artists = User.where("profile_type = ?", 'Artist').order('like_count DESC').limit(20)
    news_category = NewsCategory.find_by(name: 'Production Coverage')
    @news_behind_scenes = News.where("category_id::jsonb ?| array['" + news_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
    news_trailer_category = NewsCategory.find_by(name: 'Trailers')
    @news_movies = News.where("category_id::jsonb ?| array['" + news_trailer_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
    news_tutorial_category = NewsCategory.find_by(name: 'Tutorials')
    @news_tutorials = News.where("category_id::jsonb ?| array['" + news_tutorial_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(4)
    news_press_category = NewsCategory.find_by(name: 'Industry News')
    @news_press_data = News.where("category_id::jsonb ?| array['" + news_press_category.id.to_s + "'] AND is_approved = TRUE AND visibility = 0 AND status = 1 AND show_on_cgmeetup = TRUE AND (publish = 1 OR (publish = 0 AND to_timestamp(schedule_time, 'YYYY-MM-DD hh24:mi')::timestamp without time zone <= CURRENT_TIMESTAMP::timestamp without time zone))").order('random()').limit(3)
    # Add association between NewsCategory and News to optimize this code
  end
end
