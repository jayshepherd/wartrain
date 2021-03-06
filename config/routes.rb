ActionController::Routing::Routes.draw do |map|
  #map.connect '/movies/newest', :controller => :movies, :action => :newest
  #map.resources :movies
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
     map.namespace :admin do |admin|
       #admin.resources :content_types, :active_scaffold => true
       admin.resources :directories, :active_scaffold => true, 
                       :collection => {:scan_all => :get}
       admin.resources :assets, :active_scaffold => true
       admin.resources :movies, :active_scaffold => true,
                       :collection => {:update_all_metadata => :get, 
                                       :update_metadata => :get}
       admin.resources :asset_types, :active_scaffold => true
       admin.resources :genres, :active_scaffold => true
       admin.resources :promotions, :active_scaffold => true
       admin.resources :delayed_jobs, :active_scaffold => true
     end
     
   map.connect 'admin', :controller => 'admin/directories'
   
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "content_types"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
