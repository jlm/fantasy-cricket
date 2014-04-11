Hartlapp::Application.routes.draw do

  resources :tokens
  match '/tokens/:id/mail', to: "tokens#mail", via: 'post'

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
  get "password_resets/new"
  resources :password_resets
  match 'password_resets/new', to: "password_resets#create", via: 'post'
  
  resources :teams,     only: [:create, :destroy] do
    member do
      post 'players', :to => "teams#add_player", :as => :add_player_to
      delete 'players', :to => "teams#remove_player", :as => :remove_player_from
      get 'player_scores', :to => "player_scores#teamindex", :as => :list_ps
      post 'validate', :to => "teams#validate", :as => :validate
    end
  end

    match '/settings', to: 'settings#index',      via: 'get'
    match '/settings/:id/edit', to: 'settings#edit',      via: 'get'
    match '/settings/:id', to: 'settings#update', via: 'post'
    match '/settings/:id/toggle', to: 'settings#toggle', via: 'post'

  # You can have the root of your site routed with "root"
  root 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

end
