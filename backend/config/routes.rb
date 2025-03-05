Rails.application.routes.draw do
  get "feed/index"
  root to: 'vue#index'
  
  get 'vue/index'
  get 'home/index'
  
  resource :session, only: [:new, :create, :destroy]
  delete 'logout', to: 'sessions#destroy'
  
  resources :passwords, only: [:new, :create, :edit, :update], param: :token
  
  get 'signup', to: 'registrations#new'
  post 'signup', to: 'registrations#create'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      patch 'profile_image', to: 'users#update_profile_image'
      get 'following', to: 'users#following'
      get 'followers', to: 'users#followers'
    end

    resources :works, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :works do
    resource :favorites, only: [:create, :destroy]
  end

  # フォロー関連のルーティング
  resources :relationships, only: [:create, :destroy]
  get 'relationships/find_by_user/:user_id', to: 'relationships#find_by_user'
  
  # フィード関連のルーティング
  get 'feed', to: 'feed#index'

end