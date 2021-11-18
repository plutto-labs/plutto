Rails.application.routes.draw do
  default_url_options host: ENV.fetch("APPLICATION_HOST")

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope path: '/api/internal' do
    api_version(module: 'Api::Internal::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      get 'analytics/customers', to: 'analytics#customers'
      get 'analytics/numbers', to: 'analytics#numbers'
      get 'analytics/subscriptions/:currency', to: 'analytics#subscriptions'
      get 'analytics/mrr_and_arr/:currency', to: 'analytics#mrr_and_arr'
      resources :api_keys, only: [:create, :index, :destroy]
      resources :auth, only: [:create]
      delete 'auth', to: 'auth#destroy'
      post 'sign_up', to: 'auth#sign_up'
      resources :checkouts, param: :token, only: [:show, :update]
      resources :customers, only: [:index, :show, :create, :update, :destroy] do
        resources :payment_methods, only: [:create]
      end
      patch 'invoices/:id/change_status', to: 'invoices#change_status'
      patch 'invoices/:id/mark_as', to: 'invoices#mark_as'
      resources :invoices, only: [:index, :show]
      resources :meters, only: [:index, :show, :update, :create, :destroy]
      resources :organizations, only: [:update]
      resources :payments, only: [:index, :show]
      resources :permissions, only: [:index, :create, :destroy]
      resources :permission_groups, only: [:index, :show, :create, :update, :destroy]
      resources :products, only: [:index, :show, :create, :update, :destroy] do
        resources :pricings, only: [:create, :update, :destroy]
      end
      resources :subscriptions, only: [:create] do
        patch 'edit_trial', to: 'subscriptions#edit_trial'
        patch 'add_pricings', to: 'subscriptions#add_pricings'
        patch 'remove_pricings', to: 'subscriptions#remove_pricings'
        patch 'end_subscription', to: 'subscriptions#end_subscription'
        patch 'end_billing_period', to: 'subscriptions#end_billing_period'
      end
      resources :users, only: [:show]
    end
  end
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :customers do
        get 'has_permission/:permission_name', to: 'customers#permission'
      end
      resources :meter_events, only: [:create]
      resources :invoices, only: [:index, :show]
      patch 'invoices/:id/mark_as', to: 'invoices#mark_as'
      resources :subscriptions, only: [:create] do
        patch 'add_pricings', to: 'subscriptions#add_pricings'
        patch 'remove_pricings', to: 'subscriptions#remove_pricings'
        patch 'end_subscription', to: 'subscriptions#end_subscription'
      end
      get 'widget_settings', to: 'organizations#widget_settings'
      resources :permission_groups, only: [:index]
      resources :products, only: [:index]
    end
  end
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  devise_for :users, controllers: {
    passwords: 'passwords'
  }
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'home/admin', to: 'home#admin', as: 'admin_app'
  get 'admin/login_as/:id', to: 'admin#login_as', as: 'admin_login_as'

  get 'widget', to: 'widget#index'
  get 'invoicing', to: 'landings#invoicing', as: 'invoicing'
  post 'send_invoice_email', to: 'landings#send_invoice_email', as: 'send_invoice_email'
end
