require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'
  get 'monitoring/nagios/resque/failed', to: 'monitoring#nagios_resque_failed'

  scope module: :fixed_assets do
    resources :commodities, except: :destroy do
      get  'purchase_orders'
      post 'purchase_orders', to: 'commodities#link_purchase_order'
      get  'vouchers'
      post 'vouchers', to: 'commodities#link_voucher'
      post 'unlink', to: 'commodities#unlink_procurement'
    end
  end

  scope module: :administration do
    resources :currencies, except: :destroy
    resources :sum_levels
    resources :accounts
    resources :fiscal_years, except: :destroy
  end

  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
