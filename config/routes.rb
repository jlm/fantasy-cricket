Hartlapp::Application.routes.draw do

  resources :matches do
    resources :innings do
#      member do
#        get 'player_scores', :to => 'player_scores#innindex', :as => :list_innings_ps
#      end
      resources :player_scores
    end
  end  
  resources :teams

  get "users/new"
  resources :players do
    member do
      post 'player_scores/:player_score_id', :to => "players#apply_player_score", :as => :apply_player_score_to
      delete 'player_scores/:player_score_id', :to => "players#apply_player_score", :as => :unapply_player_score_from
      get 'player_scores', :to => "player_scores#playerindex", :as => :list_ps
    end
  end
  resources :users
  resources :sessions,  only: [:new, :create, :destroy]
  resources :teams,     only: [:create, :destroy] do
    member do
      post 'players', :to => "teams#add_player", :as => :add_player_to
      delete 'players', :to => "teams#remove_player", :as => :remove_player_from
      get 'player_scores', :to => "player_scores#teamindex", :as => :list_ps
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

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
