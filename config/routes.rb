Rails.application.routes.draw do
  #mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end

  

  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'sessions', omniauth_callbacks: 'omniauth_callbacks'}
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  

  root 'galleries#gallery'

  get 'setting/index' 
  get 'setting/general'
  get 'appearance/index'
  get 'comment/index'
  get 'content/index'


  get 'setting/test'               => 'setting#test', as: 'test' 
  post 'setting/create_test'       => 'setting#create_test', as: 'create_test' 


  get 'users/login'
  get 'user-signup' => 'user#signup'
  get 'forgot-password'=> 'user#forgotpassword'


  get 'user/dashboard'                    => 'user#dashboard', as: 'dashboard' 
  get 'user/get_stats'                    => 'user#get_stats', as: 'get_stats' 
  get 'user/user-stats/:id'               => 'user#user_stats', as: 'user_stats' 
  
  get 'user/index'
  get 'user/add'
  get 'user/profile'
  get 'user/feed'
  get 'user/trending'
  get 'user/following'
  get 'user/followers'
  get 'bookmark' => 'user#bookmark'
  get 'user/notification' 
  get 'user/user_followers'
  get 'user/user_following'
  
  get 'user/user_statistics' 
  post 'save_view_count_user'            => 'user#save_view_count', as: 'save_view_count_user' 


  get 'connection-followers' => 'user#connection_followers', as: 'connection_followers' 
  get 'connection-following' => 'user#connection_following', as: 'connection_following' 
  get 'likes' => 'user#user_like', as: 'user_like' 
  get 'user/get_user_likes' => 'user#get_user_likes', as: 'get_user_likes' 
  get 'user/get_connection_followers' => 'user#get_connection_followers', as: 'get_connection_followers' 
  get 'user/get_connection_following' => 'user#get_connection_following', as: 'get_connection_following' 
  get 'user/get_artist_list' => 'user#get_artist_list', as: 'get_artist_list' 
  get 'user/search_all_artists'                     => 'user#search_all_artists', as: 'search_all_artists' 


  get 'activity' => 'user#all_activity', as: 'all_activity' 
  get 'setting' => 'user#user_setting', as: 'user_setting' 
  post 'update_profile' => 'user#update_profile', as: 'update_profile' 
  post 'update_userprofile' => 'user#update_userprofile', as: 'update_userprofile' 
  post 'update_username' => 'user#update_username', as: 'update_username' 
  post 'blocked_users' => 'user#blocked_users', as: 'blocked_users' 
  post 'notification_setting' => 'user#notification_setting', as: 'notification_setting' 
  get 'portfolio' => 'user#user_portfolio', as: 'user_portfolio' 
  get 'profile' => 'user#user_profile_info', as: 'my_profile' 
  get 'user-jobs' => 'user#user_jobs', as: 'user_jobs' 

  get 'about-us/:id' => 'user#other_user_profile', as: 'user_profile_info' 

  get 'edit-profile' => 'user#edit_profile', as: 'edit_profile' 
  get 'user/unfollow_artist' => 'user#unfollow_artist', as: 'unfollow_artist' 
  get 'user/unfollow_user' => 'user#unfollow_user', as: 'unfollow_user' 
  get 'connection' => 'user#connection', as: 'connection' 




  get 'tutorials'=> 'tutorials#index'
  get 'tutorials/get_tutorial_list'
  get 'tutorials/get_subject_list'
 # get 'tutorials/free_tutorial'
 # get 'tutorials/tutorial_post'
  get 'tutorials/tutorial_category/:id'           => 'tutorials#tutorial_category', as: 'tutorial_category'
  get 'tutorials/tutorial_all_category'
  get 'tutorials/get_topic_type_list'             => 'tutorials#get_topic_type_list', as: 'get_topic_type_list'
  get 'tutorials/all'                             => 'tutorials#all_topic_type', as: 'all_topic_type'
  get 'tutorials/free'                            => 'tutorials#free_tutorial', as: 'free_tutorial'  
  post 'tutorials/save_like'                      => 'tutorials#save_like', as: 'tutorialsave_like' 
  post 'tutorials/check_save_like'                => 'tutorials#check_save_like', as: 'check_tutorialsave_like' 
  post 'tutorials/follow_artist'                  => 'tutorials#follow_artist', as: 'tutorial_follow_artist' 
  post 'tutorials/check_follow_artist'            => 'tutorials#check_follow_artist', as: 'check_tutorialfollow_artist'  
  post 'tutorials/save_comment'                   => 'tutorials#save_comment', as: 'save_tutorial_comment' 
  get 'tutorials/get_comment'                     => 'tutorials#get_comment', as: 'get_tutorial_comment' 

  get 'dashboard/tutorials/new'                   => 'tutorials#new', as: 'create_tutorial' 
  post 'tutorials/create'                         => 'tutorials#create',as: 'save_tutorial'
  get 'dashboard/tutorials'                       => 'tutorials#listing_index', as: 'index_tutorial'
  get 'dashboard/tutorials/:paramlink/edit'       => 'tutorials#edit', as: 'modify_tutorial' 
  patch 'tutorials/:paramlink/update'             => 'tutorials#update', as: 'update_tutorial' 
  get 'tutorials/:paramlink/show'                 => 'tutorials#show', as: 'show_tutorial' 
  get 'get_free_tutorial_subject_detail'          => 'api#get_free_tutorial_subject_detail', as: 'get_free_tutorial_subject_detail' 
  
  get 'get_tutorial_info/:paramlink'              => 'api#get_tutorial_info', as: 'get_tutorial_info' 
  
  get 'tutorials/:paramlink/make_trash'           => 'tutorials#make_trash', as: 'trash_tutorial'
  get 'tutorials/:paramlink/delete_from_trash'    => 'tutorials#delete_from_trash', as: 'delete_tutorial_from_trash'
  get 'tutorials/:paramlink/restore_tutorial'     => 'tutorials#restore_tutorial', as: 'restore_tutorial'

  post 'tutorials/save_tutorial_rating'           => 'tutorials#save_tutorial_rating', as: 'save_tutorial_rating'
  post 'tutorials/get_tutorial_avg_rating'        => 'tutorials#get_tutorial_avg_rating', as: 'get_tutorial_avg_rating'

  get 'tutorials/all'                             => 'tutorials#all_topic', as: 'all_topic'     
  post 'tutorials/get_like_comment_view_tutorial' => 'tutorials#get_like_comment_view_tutorial', as: 'get_like_comment_view_tutorial'   
  post 'tutorials/mark_spam'                      => 'tutorials#mark_spam', as: 'mark_spam_tutorial' 
  post 'tutorials/check_mark_spam'                => 'tutorials#check_mark_spam', as: 'check_mark_spam_tutorial' 


  get 'tutorials/get_topic_type_subject_detail_list/:topic' => 'tutorials#get_topic_type_subject_detail_list', as: 'get_topic_type_subject_detail_list'   

  get 'tutorials/get_usertutorial_list'            => 'tutorials#get_usertutorial_list', as: 'get_usertutorial_list'
  get 'tutorials/count_user_tutorial_post'         => 'tutorials#count_user_tutorial_post', as: 'count_user_tutorial_post'
  get 'tutorials/get_filter_values'                => 'tutorials#get_filter_values', as: 'get_tutorial_filter_values'  

  get 'tutorials/get_topic_subject_detail/:topic'  => 'tutorials#get_topic_subject_detail', as: 'get_topic_subject_detail' 
 
  get 'tutorials/get_tutorial_subject_list'        => 'tutorials#get_tutorial_subject_list', as: 'get_tutorial_subject_list' 
  
  post 'tutorials/delete_tutorial_post'            => 'tutorials#delete_tutorial_post', as: 'delete_tutorial_post'

  get 'tutorials/get_topic_subject_tutorials_list' => 'tutorials#get_topic_subject_tutorials_list', as: 'get_topic_subject_tutorials_list'   

  get 'tutorials/get_topic_list' => 'tutorials#get_topic_list', as: 'get_topic_list' 

  get 'get_latest_tutorial/:user_id'            => 'api#get_latest_tutorial', as: 'get_latest_tutorial'

  get 'get_latest_tutorial_sale/:user_id'                => 'api#get_latest_tutorial_sale', as: 'get_latest_tutorial_sale'

  get 'get_monthly_tutorial_summary/:user_id'            => 'api#get_monthly_tutorial_summary', as: 'get_monthly_tutorial_summary'

  get 'message' => 'messages#index', as: 'message'
  get 'store/index'

  get 'job/index'
  #get 'job/get_job_list'
  get 'job/store'
  get 'job/job_post'
  get 'jobs'=> 'job#job_home'
  get 'jobs/:id'=> 'job#apply_job', as: 'apply_job' 
  get 'company/:id/jobs'=> 'user#apply_job', as: 'user_apply_job' 
  get 'job/job_category' 
  #get 'job/job_company_list_on_map'
  
  get 'job/map'=> 'job#job_list_on_map', as: 'job_list_on_map'
  get 'companies/map'=> 'job#job_company_list_on_map', as: 'job_company_list_on_map'
  
  get 'dashboard/jobs/new'  => 'job#new', as: 'create_job'
  get 'dashboard/jobs'   => 'job#listing_index', as: 'index_job'
  
  get 'job/:paramlink/make_trash'    => 'job#make_trash', as: 'trash_job'
  get 'job/:paramlink/delete_from_trash'    => 'job#delete_from_trash', as: 'delete_job_from_trash'
  get 'job/:paramlink/restore_job'          => 'job#restore_job', as: 'restore_job'

  post 'job/create'                  => 'job#create',as: 'save_job'
  get 'job/count_user_job_post'      => 'job#count_user_job_post', as: 'count_user_job_post'
  get 'job/get_job_list'             => 'job#get_job_list', as: 'get_job_list'
  get 'dashboard/jobs/:paramlink/edit' => 'job#edit', as: 'modify_job' 
  patch 'job/:paramlink/update'      => 'job#update', as: 'update_job' 
  
  get 'job/get_job_home_list'        => 'job#get_job_home_list', as: 'get_job_home_list' 
  get 'job/get_company_job_list'     => 'job#get_company_job_list', as: 'get_company_job_list' 
  
  get 'job/applied-job/:paramlink'  => 'job#applied_job', as: 'applied_job' 
  post 'job/follow_job'           => 'job#follow_job', as: 'follow_job' 
  post 'job/check_follow_job'     => 'job#check_follow_job', as: 'check_follow_job'

  put 'update_user_image'         => 'job#update_user_image'
  delete 'remove_cover_art'       => 'job#remove_cover_art'

  post 'save_job_view_count'             => 'job#save_job_view_count', as: 'save_job_view_count' 
  post 'jobs/delete_job_post'            => 'job#delete_job_post', as: 'delete_job_post' 
  post 'jobs/mark_spam'                  => 'job#mark_spam', as: 'mark_spam' 
  post 'jobs/check_mark_spam'            => 'job#check_mark_spam', as: 'check_mark_spam' 
    
  resources :user, only: [:edit, :update]

  
  resources :galleries

    

    get 'dashboard/projects'                          => 'galleries#index', as: 'index_gallery' 
    get 'dashboard/projects/new'                      => 'galleries#new', as: 'create_gallery' 
    get 'dashboard/projects/:paramlink/edit'          => 'galleries#edit', as: 'modify_gallery' 
    get 'get_video_detail_from_url'                   => 'galleries#get_video_detail_from_url'
    get 'getsubjectmatter'                            => 'galleries#getsubjectmatter'
    post 'upload_drag_image'                          => 'galleries#upload_drag_image'
    get 'dashboard/projects/:paramlink/show'          => 'galleries#show', as: 'show_gallery' 
    get 'get_upload_video_thumbnail'                  => 'galleries#get_upload_video_thumbnail', as: 'get_upload_video_thumbnail'
    get 'dashboard/projects/:paramlink/make_trash'    => 'galleries#make_trash', as: 'trash_gallery'
    get 'dashboard/projects/:paramlink/delete_from_trash'    => 'galleries#delete_from_trash', as: 'delete_post_from_trash'
    get 'dashboard/projects/:paramlink/restore_post'    => 'galleries#restore_post', as: 'restore_post'


    get 'dashboard/projects/get_gallery_post_list'    => 'galleries#get_gallery_post_list', as: 'get_gallery_post_list'
    get 'dashboard/projects/count_user_gallery_post'  => 'galleries#count_user_gallery_post', as: 'count_user_gallery_post'
    post 'dashboard/projects/save_like'               => 'galleries#save_like', as: 'save_like' 
    post 'dashboard/projects/check_save_like'         => 'galleries#check_save_like', as: 'check_save_like' 
    post 'dashboard/projects/follow_artist'           => 'galleries#follow_artist', as: 'follow_artist' 
    post 'dashboard/projects/check_follow_artist'     => 'galleries#check_follow_artist', as: 'check_follow_artist'    
    get 'dashboard/projects/get_gallery_list'                 => 'galleries#get_gallery_list', as: 'get_gallery_list' 
    get 'dashboard/projects/get_portfolio_list'               => 'galleries#get_portfolio_list', as: 'get_portfolio_list' 
    get 'search'                                              => 'galleries#search', as: 'search' 
    get 'dashboard/projects/search_all_projects'              => 'galleries#search_all_projects', as: 'search_all_projects' 
    post 'dashboard/projects/save_comment'                    => 'galleries#save_comment', as: 'save_comment' 
    get 'dashboard/projects/get_comment'                      => 'galleries#get_comment', as: 'get_comment' 
    get 'dashboard/projects/get_artist_gallery'                => 'galleries#get_artist_gallery', as: 'get_artist_gallery' 


    post 'dashboard/projects/get_like_comment_view_gallery'   => 'galleries#get_like_comment_view_gallery', as: 'get_like_comment_view_gallery' 
    post 'save_view_count'            => 'galleries#save_view_count', as: 'save_view_count' 
    post 'get_subject_matter_list'    => 'galleries#get_subject_matter_list', as: 'get_subject_matter_list' 
    post 'dashboard/projects/delete_galleries_post'    => 'galleries#delete_galleries_post', as: 'delete_galleries_post' 
  

    get 'artwork'               => 'galleries#browse_all_artwork', as: 'browse_all_artwork' 
    get 'gallery'               => 'galleries#browse_all_gallery', as: 'browse_all_gallery' 
    get 'videos'                => 'galleries#browse_all_video', as: 'browse_all_video' 
    get 'wips'                  => 'galleries#browse_all_work_in_progress', as: 'browse_all_work_in_progress' 
    get 'users'                 => 'user#browse_all_artist', as: 'browse_all_artist' 
    get 'companies'             => 'user#browse_all_companies', as: 'browse_all_companies' 
    get 'challenge'             => 'galleries#browse_all_challenge', as: 'browse_all_challenge' 
    get 'awards'                => 'galleries#browse_all_awards', as: 'browse_all_awards' 
    

   resources :collections
    
    get  'bookmarks'                                => 'collections#index', as: 'index_collection'
    post 'create_bookmark'                          => 'collections#new', as: 'create_collection'
    patch 'update_bookmark'                         => 'collections#update_collection', as: 'update_collection'
    get  'bookmark/:paramlink/bookmarks'            => 'collections#show', as: 'collection_detail'
    get  'bookmarkdelete'                           => 'collections#collectiondelete', as: 'collectiondelete'
    get  'get_all_bookmark'                         => 'collections#get_all_collection', as: 'get_all_collection'

    resources :reports

    get  'report'                                     => 'reports#index', as: 'index_report'
    post 'create_report'                              => 'reports#new', as: 'create_report'

  
    get  'contest'                                => 'challenges#index', as: 'challenge_home'
    get  'contest/get_challenge_list'             => 'challenges#get_challenge_list'
    get  'contest/:id/show'                       => 'challenges#show', as: 'show_challenge' 
    get  'contest/get_challengers_count'          => 'challenges#get_challengers_count', as: 'get_challengers_count' 
    post 'contest/save_view_count'                => 'challenges#save_view_count', as: 'save_challenge_view_count' 
    
    resources :contests
    get 'contests'                                => 'contests#index', as: 'contests_home' 
    get 'contests/new'                            => 'contests#new', as: 'create_contest' 
    get 'get_contest_post_list'                   => 'contests#get_contest_post_list'
    get 'get_all_submission'                      => 'contests#get_all_submission'
    get 'contests/:paramlink/make_trash'          => 'contests#make_trash', as: 'trash_contest'
    get 'contests/:paramlink/edit'                => 'contests#edit', as: 'modify_contest' 
    post 'contests/upload_drag_image'             => 'contests#upload_drag_image'
    get 'contests/:paramlink/show'                => 'contests#show', as: 'show_contest' 
    get 'contests/join_challenge/:challenge_type_id'    => 'contests#join_challenge', as: 'join_challenge' 

    post 'contests/save_like'                      => 'contests#save_like', as: 'save_contest_like' 
    post 'contests/check_save_like'                => 'contests#check_save_like', as: 'check_contest_save_like' 
    post 'contests/save_view_count'                => 'contests#save_view_count', as: 'save_contest_view_count' 
    get  'get_winner_list'                         => 'contests#get_winner_list', as: 'get_winner_list' 
    get  'get_honour_list'                         => 'contests#get_honour_list', as: 'get_honour_list' 
    post 'contests/follow_contest'                 => 'contests#follow_contest', as: 'follow_contest' 
    post 'contests/check_follow_contest'           => 'contests#check_follow_contest', as: 'check_follow_contest'   



    get 'news/index'
    get 'news/free_news'
    get 'news/news_category'
    get 'news/news_all_category'
    get 'news/news_post'
    get 'news/get_news_list'
    get 'news/get_category_list'
    get 'news/:paramlink/show'            => 'news#show', as: 'show_news' 
    post 'news/check_save_like'           => 'news#check_save_like', as: 'check_newssave_like' 
    post 'news/check_follow_artist'       => 'news#check_follow_artist', as: 'check_newsfollow_artist'
    post 'news/follow_artist'             => 'news#follow_artist', as: 'news_follow_artist'
    post 'news/save_like'                 => 'news#save_like', as: 'newssave_like' 
 
    post 'news/save_news_rating'           => 'news#save_news_rating', as: 'save_news_rating'
  	post 'news/get_news_avg_rating'        => 'news#get_news_avg_rating', as: 'get_news_avg_rating'



  get 'downloads'=> 'downloads#download'
  
  get 'downloads/get_download_list'
  get 'downloads/get_post_type_category_list'
  #get 'downloads/download_category'
  #get 'downloads/download_detail'
  get 'downloads/download_post'
  get 'downloads/free'      => 'downloads#free_download', as: 'free_download'  
  

  get 'downloads/get_post_type_list' => 'downloads#get_post_type_list', as: 'get_post_type_list'   
  get 'downloads/get_post_type_category_detail_list/:post_type' => 'downloads#get_post_type_category_detail_list', as: 'get_post_type_category_detail_list'   
 
  get 'downloads/get_post_type_category_detail/:category_type' => 'downloads#get_post_type_category_detail', as: 'get_post_type_category_detail'   
 
  get 'downloads/get_post_type_category_downloads_list' => 'downloads#get_post_type_category_downloads_list', as: 'get_post_type_category_downloads_list'   
  
  get 'downloads/get_userdownload_list'            => 'downloads#get_userdownload_list', as: 'get_userdownload_list'
  
  get 'downloads/get_free_category_downloads_list' => 'downloads#get_free_category_downloads_list', as: 'get_free_category_downloads_list'   
  
  post 'downloads/delete_download_post'            => 'downloads#delete_download_post', as: 'delete_download_post'
  
  get 'downloads/count_user_download_post'      => 'downloads#count_user_download_post', as: 'count_user_download_post'
  get 'downloads/get_filter_values' => 'downloads#get_filter_values', as: 'get_filter_values'   
  get 'api/get_software_expertises_list' => 'api#get_software_expertises_list', as: 'get_software_expertises_list'   
  get 'api/get_renderers_list' => 'api#get_renderers_list', as: 'get_renderers_list'   
  get 'downloads/all' => 'downloads#all_post_type', as: 'all_post_type'   
  
  post 'downloads/get_like_comment_view_download' => 'downloads#get_like_comment_view_download', as: 'get_like_comment_view_download'   
  

  post 'downloads/mark_spam'                    => 'downloads#mark_spam', as: 'mark_spam_download' 
  post 'downloads/check_mark_spam'              => 'downloads#check_mark_spam', as: 'check_mark_spam_download' 
  post 'downloads/update_number_of_downloads'   => 'downloads#update_number_of_downloads', as: 'update_number_of_downloads' 

   
  get 'dashboard/downloads/new'                 => 'downloads#new', as: 'create_download' 
  post 'downloads/create'                       => 'downloads#create',as: 'save_download'
  get 'dashboard/downloads'                     => 'downloads#listing_index', as: 'index_download'
  get 'dashboard/downloads/:paramlink/edit'     => 'downloads#edit', as: 'modify_download' 
  patch 'downloads/:paramlink/update'           => 'downloads#update', as: 'update_download' 
  get 'downloads/:paramlink/show'               => 'downloads#show', as: 'show_download' 
  get 'get_free_download_category_detail'       => 'api#get_free_download_category_detail', as: 'get_free_download_category_detail' 
  
  get 'get_download_info/:paramlink'            => 'api#get_download_info', as: 'get_download_info' 
  
  get 'downloads/:paramlink/make_trash'         => 'downloads#make_trash', as: 'trash_download'
  get 'downloads/:paramlink/delete_from_trash'  => 'downloads#delete_from_trash', as: 'delete_download_from_trash'
  get 'downloads/:paramlink/restore_download'   => 'downloads#restore_download', as: 'restore_download'

  post 'download/save_download_rating'          => 'downloads#save_download_rating', as: 'save_download_rating'
  post 'download/get_download_avg_rating'       => 'downloads#get_download_avg_rating', as: 'get_download_avg_rating'

  post 'check_valid_coupon_code'                => 'api#check_valid_coupon_code', as: 'check_valid_coupon_code'
  get 'get_latest_sale/:user_id'                => 'api#get_latest_sale', as: 'get_latest_sale'
  get 'get_latest_download/:user_id'            => 'api#get_latest_download', as: 'get_latest_download'
  get 'get_monthly_summary/:user_id'            => 'api#get_monthly_summary', as: 'get_monthly_summary'
  
  
    get 'cart'                               => 'downloads#cart', as: 'cart'

    post 'downloads/save_like'               => 'downloads#save_like', as: 'downloadsave_like' 
    post 'downloads/check_save_like'         => 'downloads#check_save_like', as: 'check_downloadsave_like' 
    post 'downloads/follow_artist'           => 'downloads#follow_artist', as: 'download_follow_artist' 
    post 'downloads/check_follow_artist'     => 'downloads#check_follow_artist', as: 'check_downloadfollow_artist'  
    post 'downloads/save_comment'            => 'downloads#save_comment', as: 'save_download_comment' 
    get 'downloads/get_comment'              => 'downloads#get_comment', as: 'get_download_comment' 



    post 'checkout_paypal'                    => 'orders#checkout_paypal', as: 'checkout_paypal'
    post 'checkout_credit_card_paypal'        => 'orders#checkout_credit_card_paypal', as: 'checkout_credit_card_paypal'
    get 'paypal-success'                      => 'orders#paypal_success', as: 'paypal_success'    
    post '/hook', to: 'orders#hook', as: 'hook'   


  get  'coupons/new'                          => 'store#new_coupon', as: 'create_coupon'
  post 'coupons/create'                       => 'store#create_coupon',as: 'save_coupon'
  get  'coupons/:paramlink/edit'              => 'store#edit_coupon', as: 'modify_coupon' 
  delete  'coupons/delete'                    => 'store#coupon_delete', as: 'coupon_delete' 
  patch 'coupons/:paramlink/update'           => 'store#update_coupon', as: 'update_coupon'
  

  

  get 'user-profile/:id'         => 'user#artist_profile', as: 'artist_profile' 
  get 'update_read_notification' => 'user#update_read_notification', as: 'update_read_notification' 

  post 'save_qb_data' => 'user#save_qb_data'
  

  namespace :admin do
	 post 'images/saveimage' => 'images#saveimages'
  end


  get 'tutorials/:topic'                              => 'tutorials#tutorial_detail', as: 'tutorial_detail'   
  get 'tutorials/:topic/:subject'                     => 'tutorials#tutorial_subject', as: 'tutorial_subject'   
  get 'tutorials/:topic/:subject/:sub_subject'        => 'tutorials#tutorial_sub_subject', as: 'tutorial_sub_subject'  


  

  get 'downloads/:post_type'                                    => 'downloads#download_detail', as: 'download_detail'   
  get 'downloads/:post_type/:category_type'                     => 'downloads#download_category', as: 'download_category'   
  get 'downloads/:post_type/:category_type/:sub_category_type'  => 'downloads#download_sub_category', as: 'download_sub_category'  

  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
