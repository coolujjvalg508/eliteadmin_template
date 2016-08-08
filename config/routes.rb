Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :users, controllers: { sessions: 'users/registrations' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get 'setting/index' 
  get 'setting/general'

  get 'appearance/index'

  get 'comment/index'

  get 'content/index'

  get 'tutorial/index'
  
  get 'store/index'

  get 'job/index'
  get 'job/store'
  get 'job/job_post'

  get 'user-signup' => 'user#signup'
  get 'forgot-password'=> 'user#forgotpassword'
  get 'user/all_activity'
  get 'user/dashboard'
  get 'user/message'
  get 'user/index'
  get 'user/add'
  get 'user/profile'
  get 'user/feed'
  get 'user/trending'
  get 'user/following'
  get 'user/followers'
  get 'bookmark' => 'user#bookmark'
  get 'user/notification'
  get 'user/browse_all_artist'
  get 'user/connection_followers'
  get 'user/connection_following'
  get 'user/edit_profile'
  get 'user/join_challenge'
  get 'user/user_followers'
  get 'user/user_following'
  get 'user/user_like'
  get 'user/user_profile_info'
  get 'user/user_statistics'
  
  get 'gallery/all_gallery_post'
  get 'gallery/browse_all_artwork'
  get 'gallery/browse_all_awards'
  get 'gallery/browse_all_challenge'
  get 'gallery/browse_all_companies'
  get 'gallery/browse_all_gallery'
  get 'gallery/browse_all_video'
  get 'gallery/browse_all_work_in_progress'
  get 'gallery/challenge'
  get 'gallery/challenge_post'
  get 'gallery/create_gallery_post_type'
  get 'gallery/gallery'
  get 'gallery/wip_detail'
  get 'download-gallery'=> 'gallery#download'

  root 'gallery#index'	
  
  
  
  
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
