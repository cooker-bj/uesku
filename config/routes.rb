Uesku::Application.routes.draw do

  #get "locations/index"
  #match 'locations/select'

  get "categories/index"
  match "categories/subcategory"

  

  get "profile/show"

  get "main/index"
  match "main/category/:id"  =>"main#category" ,:as=>:main_category
  match "main/location/:id"  =>"main#location", :as=>:main_location
  resources :locations,:only=>[:index] do 
    match 'seletct', :on=>:collection
    get 'set_city', :on=>:member
  end 

  resources :calendar_events

  resources :my_lessons

  resources :short_messages do
    get 'manage',:on=>:member
    get 'reply', :on=>:member
    post 'new_message',:on=>:collection
    get 'show_messages',:on=>:member
    post 'add_users',:on=>:collection
    post 'remove_users',:on=>:collection
    get 'new_messages',:on=>:member
  end

 # resources :messengers

  resources :friendships  do
    get  'agree',:on=>:member
  end

 

  #resources :post_comments

  resources :posts  do
    get 'set_to_top',:on=>:member
    get 'set_to_distillate',:on=>:member
    get 'withdraw_to_top', :on=>:member
    get 'withdraw_distillate',:on=>:member
    resources :comments ,:name_prefix=>"post_"
  end




 resources :groups do
    resources  :posts,:name_prefix=>"group_"
    post "add_member",:on=>:member
    get 'administration',:on=>:member
   get 'approval_member',:on=>:member
   get 'reject_member',:on=>:member
   get 'set_manager',:on=>:member
   get 'withdraw_manager',:on=>:member
 end



  devise_for :admins, :controllers =>{:sessions=>'admin/sessions'}
  get 'admin/companies'=>'admin/companies#index',:as=>:admin_root

  devise_for :users#, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",:registrations=>"users/registrations",:sessions=>"users/sessions" }
  get '/users/auth/google_oauth2/callback'=>'users/omniauth_callbacks#google_oauth2'
  get '/users/auth/weibo/callback'=>'users/omniauth_callbacks#weibo'
  get '/users/auth/qq_connect/callback'=>'users/omniauth_callbacks#qq_connect'

 

  resources :users,:only=>[:show] do
    get 'groups',:on=>:member
    get 'messenger',:on=>:member
    get 'profile',:on=>:member

  end

  resources :companies ,:execpt=>[:destroy] do 
    get :select_company, :on=>:collection
    get 'history',:on=>:member
    post 'compare',:on=>:member
    get 'undo',:on=>:member
  end

  resources :lessons, :except=>[:destroy] do
    resources :comments,:name_prefix=>"lesson_"
    resources :scores
    resources :timetables,:name_prefix=>"lesson_"
    get 'undo',:on=>:member
    match 'category',:on=>:member,:via=>[:post,:get]
    match 'district',:on=>:member,:via=>[:post,:get]
    match 'course',:on=>:collection
    get 'history', :on=>:member
    post 'compare',:on=>:member
    get 'company',:on=>:collection
    
  end
  # post 'lessons' =>'lessons#index'
  resources :timetables do
    get 'register_user',:on=>:member
    delete 'withdraw_user',:on=>:member
    get 'edit_calendar',:on=>:member
    post 'remove_class_time',:on=>:member
    post 'update_class_time', :on=>:member
    resources :comments,:name_prefix=>"timetable_"
  end

  resources :comments
  resources :replies


  post 'query/group_member_for_management'=>'query#group_member_for_management'
  get 'query/query_companies_auto'
  post 'query/query_companies'

  namespace :api,defaults: {format: 'json'} do 
    namespace :v1 do 
      devise_for :users
      resources :calendar_events
      resources :users,:only=>[:show]
      resources :short_messages do
        get 'manage',:on=>:member
        get 'reply', :on=>:member
        post 'new_message',:on=>:collection
        get 'show_messages',:on=>:member
        post 'add_users',:on=>:collection
        post 'remove_users',:on=>:collection
        get 'new_messages',:on=>:member
      end
      resources :friendships  do
        get  'agree',:on=>:member
      end
    end
  end

  namespace :admin do
    resources :admins
    resources :branches,:except=>[:index,:show,:new]
    resources :lessons  do
      get 'set_audit',:on=>:member
      get 'withdraw_audit',:on=>:member
      get 'list',:on=>:collection
      resources :recommendations
    end
    resources :categories   do
      post 'select', :on=>:collection
      post 'course_select',:on=>:collection
    end
    resources :locations   do
      post 'select', :on=>:collection
      
    end

    resources :companies do
    resources :branches
     get  'set_audit', :on=>:member
     get  'withdraw_audit', :on=>:member
    resources :courses    do
      get  'set_audit', :on=>:member
      get  'withdraw_audit', :on=>:member
    end
    end


  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  authenticated :user do
    root :to=>'users#show'
  end
  authenticated :admin do 
    root :to=>'admin::lessons#index'
  end
  root :to => 'main#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
