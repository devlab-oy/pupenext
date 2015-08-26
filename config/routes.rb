require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'
  get 'monitoring/nagios/resque/failed', to: 'monitoring#nagios_resque_failed'

  scope module: :fixed_assets do
    resources :commodities, except: :destroy do
      get :purchase_orders
      get :sell
      get :vouchers
      post :activate
      post :confirm_sale
      post :generate_rows
      post :link_order
      post :link_voucher
      post :unlink
    end
  end

  scope module: :administration do
    resources :accounts
    resources :carriers
    resources :cash_registers
    resources :currencies, except: :destroy
    resources :fiscal_years, except: :destroy
    resources :freight_contracts
    resources :packing_areas
    resources :printers
    resources :qualifier_cost_centers, path: :qualifiers, controller: :qualifiers
    resources :qualifier_projects, path: :qualifiers, controller: :qualifiers
    resources :qualifier_targets, path: :qualifiers, controller: :qualifiers
    resources :qualifiers
    resources :sum_level_commodities, path: :sum_levels, controller: :sum_levels
    resources :sum_level_externals, path: :sum_levels, controller: :sum_levels
    resources :sum_level_internals, path: :sum_levels, controller: :sum_levels
    resources :sum_level_profits, path: :sum_levels, controller: :sum_levels
    resources :sum_level_vats, path: :sum_levels, controller: :sum_levels
    resources :sum_levels
    resources :terms_of_payments, except: :destroy
  end

  scope module: :utilities do
    get 'qr_codes/generate'
  end

  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
