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
    resources :cash_registers
    resources :currencies, except: :destroy
    resources :fiscal_years, except: :destroy
    resources :packages do
      get :edit_keyword
      get :edit_package_code
      get :new_keyword
      get :new_package_code
      post :create_keyword
      post :create_package_code
      post :update_keyword
      post :update_package_code
    end
    resources :printers
    resources :qualifiers
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
