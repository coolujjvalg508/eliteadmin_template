Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end

  root 'gallery#index'  

  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'sessions', omniauth_callbacks: 'omniauth_callbacks'}
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  
  get 'setting/index' 
  get 'setting/general'
  get 'appearance/index'
  get 'comment/index'
  get 'content/index'


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

  get 'about-us/:id' => 'user#other_user_profile', as: 'user_profile_info' 

  get 'edit-profile' => 'user#edit_profile', as: 'edit_profile' 
  get 'user/unfollow_artist' => 'user#unfollow_artist', as: 'unfollow_artist' 
  get 'user/unfollow_user' => 'user#unfollow_user', as: 'unfollow_user' 
  get 'connection' => 'user#connection', as: 'connection' 

  get 'tutorials'=> 'tutorial#index'
  get 'tutorial/get_tutorial_list'
  get 'tutorial/get_topic_list'
  get 'tutorial/free_tutorial'
  get 'tutorial/tutorial_post'
  get 'tutorial/tutorial_category/:id'=> 'tutorial#tutorial_category', as: 'tutorial_category'
  get 'tutorial/tutorial_all_category'

  get 'message' => 'messages#index', as: 'message'
  
  get 'store/index'

  get 'job/index'
  get 'job/get_job_list'
  get 'job/store'
  get 'job/job_post'
  get 'jobs'=> 'job#job_home'
  get 'job/apply_job/:id'=> 'job#apply_job', as: 'apply_job' 
  get 'job/job_category' 
  get 'job/job_company_list_on_map'
  get 'job/job_list_on_map'


  put 'update_user_image' => 'job#update_user_image'
  delete 'remove_cover_art' => 'job#remove_cover_art'
    
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

  
    get  'contest'                              => 'challenges#index', as: 'challenge_home'
    get  'contest/get_challenge_list'           => 'challenges#get_challenge_list'
    get  'contest/:id/show'                     => 'challenges#show', as: 'show_challenge' 
    get  'contest/get_challengers_count'        => 'challenges#get_challengers_count', as: 'get_challengers_count' 
    post 'contest/save_view_count'              => 'challenges#save_view_count', as: 'save_challenge_view_count' 
    
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




  get 'gallery/gallery'
  get 'gallery/wip_detail'
  get 'gallery/get_download_list'
  get 'gallery/get_post_type_category_list'
  get 'gallery/download_category'
  get 'gallery/download_detail'
  get 'gallery/download_post'

  get 'gallery/free_download'
  
  get 'news/index'
  get 'news/free_news'
  get 'news/news_category'
  get 'news/news_all_category'
  get 'news/news_post'
  get 'news/get_news_list'
  get 'news/get_category_list'
 
  get 'downloads'=> 'gallery#download'


  get 'user-profile/:id'         => 'user#artist_profile', as: 'artist_profile' 
  get 'update_read_notification' => 'user#update_read_notification', as: 'update_read_notification' 

  post 'save_qb_data' => 'user#save_qb_data'
  
  
  namespace :admin do
	 post 'images/saveimage' => 'images#saveimages'
  end
  
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
