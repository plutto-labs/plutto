Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope path: '/api/internal' do
    api_version(module: 'Api::Internal::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :api_keys, only: [:create, :index, :destroy]
      resources :auth, only: [:create]
      resources :customers, only: [:index, :show, :create, :update, :destroy] do
        resources :payment_methods, only: [:create]
      end
      get 'active_customers', to: 'customers#active'
      get 'trial_customers', to: 'customers#trial'
      patch 'invoices/:id/change_status', to: 'invoices#change_status'
      resources :invoices, only: [:index, :show]
      resources :meters, only: [:index, :show, :update, :create, :destroy]
      resources :subscriptions, only: [:create] do
        patch 'edit_trial', to: 'subscriptions#edit_trial'
      end
      resources :products, only: [:index, :show, :create, :update, :destroy] do
        resources :pricings, only: [:create, :update, :destroy]
      end
      resources :users, only: [:show]
    end
  end
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :customers
      resources :meter_events, only: [:create]
      resources :invoices, only: [:index, :show]
      resources :subscriptions, only: [:create]
      patch 'subscriptions/:id/end_subscription', to: 'subscriptions#end_subscription'
    end
  end
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  devise_for :users
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
end
