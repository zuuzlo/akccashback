Akccashback::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, :at => '/sidekiq'
  
  get "transactions/new"
  get "transactions/create"
  #get "activities/index"
  get "/sign_in", to: "sessions#new"
  post "/sign_in", to: "sessions#create"
  get "/sign_out", to: "sessions#destroy"

  root to: 'coupons#index'

  get 'ui(/:action)', controller: 'ui'
  
  resources :users, only: [:new, :create, :show, :edit, :update] do
    resources :transactions, only: [:create, :new]
    resources :activities, only: [:index]
  end

  get 'register/:token', to: "users#register_confirmation", as: 'register_with_token'
  
  resources :forgot_passwords, only: [:create]
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :stores, except: [:destroy] do
    member do 
      post 'save_store'
      post 'remove_store'
    end
  end

  resources :categories, only: [:show]
  resources :ctypes, only: [:show]
  resources :kohls_categories, only: [:show]
  resources :kohls_types, only: [:show]
  resources :kohls_onlies, only: [:show]

  resources :coupons do
    member do
      post 'toggle_favorite'
    end

    collection do
      get 'search', to: 'coupons#search'
      get 'tab_all'
      get 'tab_coupon_codes'
      get 'tab_offers'
    end
  end

  namespace :admin do
    resources :coupons, only: [:index, :new, :create, :edit, :update, :destroy]
    get 'get_kohls_coupons', to: 'coupons#get_kohls_coupons'
    get 'delete_kohls_coupons', to: 'coupons#delete_kohls_coupons'
    
    resources :activities, only: [:index]
    get 'get_activities', to: 'activities#get_activities'
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
