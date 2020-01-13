Spree::Core::Engine.routes.draw do
  devise_for :user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' }
end

Spree::Core::Engine.routes.prepend do
  resources :users, :only => [:edit, :update]

  devise_scope :user do
    get '/login' => 'user_sessions#new'
    get '/logout' => 'user_sessions#destroy'
    get '/signup' => 'user_registrations#new'
  end

  get '/checkout/registration' => 'checkout#registration'
  # Moved out from gem to App repo to use route_translator
  # due to defining two routes with the same name using :as option error in Rails 4
  # put '/checkout/registration' => 'checkout#update_registration', as: :update_checkout_registration
  # get '/orders/:id/token/:token' => 'orders#show', as: :token_order

  resource :session do
    member do
      get :nav_bar
    end
  end

  resource :account, :controller => 'users'

  namespace :admin do
    resources :users
  end
end
