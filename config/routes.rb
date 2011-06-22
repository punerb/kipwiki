Kipwiki::Application.routes.draw do


  resources :authentications
  match '/projects/search' => 'projects#search', :as => :project_search

  match '/projects/:id/photos', :to => 'projects#photos', :as => :photos
  match '/projects/:id/upload_attachment', :to => 'projects#upload_attachment', :as => :upload_attachment
  match '/projects/:print_id/delete_attachment', :to => 'projects#delete_attachment', :as => :delete_attachment


  resources :tags

  resources :project_statuses

  resources :project_types

  resources :projects, :except => [:show, :edit, :display] do
    resources :project_objectives
    member do
      post :add_suggestion
      get  :show_full_summary
    end
    
    resources :stakeholders
    resources :project_fundings
    resources :links
    resources :news
  end

  get "home/index"
  match '/filter', :to => "home#filter"
  
  devise_for :user, :controllers => { :registrations => "registrations" }
  
 
  devise_for :users
  
  match 'my_projects' => 'projects#my_projects', :as => 'user_projects'
  
  match ':city/project/:id' => 'projects#show', :as => 'show_project'
  match ':city/project/:id/edit' => 'projects#edit', :as => 'edit_project'
  match ':city/project/:id/display' => 'projects#display', :as => 'edit_project'
#  match '/user/:id' => 'devise/users#show', :as => 'show_user'
  match "/auth/:provider/callback" => "authentications#create"
  match "/auth/failure" => "authentications#failure"
  
  match 'project/:id/edit/:action_type' => 'projects#edit', :as => 'edit_project_by_action_type'
  match 'project/:id/display/:action_type' => 'projects#display', :as => 'display_project_by_action_type'

  root :to => "home#index"
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
