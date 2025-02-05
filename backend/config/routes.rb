Rails.application.routes.draw do
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

  resources :users, only: [:show, :edit, :update] do
    member do
      patch 'profile_image', to: 'users#update_profile_image'
    end
  end
  
  get 'up', to: 'rails/health#show', as: :rails_health_check
end