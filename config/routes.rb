Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope path: '/api/internal' do
    api_version(module: 'Api::Internal::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :auth, only: [:create]
      resources :customers, only: [:index, :show, :update, :create, :destroy]
      resources :plans, only: [:index, :show, :update, :create, :destroy]
      resources :meters, only: [:index, :show, :update, :create, :destroy]
    end
  end
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  devise_for :users
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
