require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'
  get 'monitoring/nagios/resque/failed', to: 'monitoring#nagios_resque_failed'

  scope module: :fixed_assets do
    resources :commodities, except: :destroy do
      get  'purchase_orders'
      get  'vouchers'
      post 'activate'
      post 'generate_rows'
      post 'link_order'
      post 'link_voucher'
      post 'unlink'
      get 'sell'
      post 'confirm_sale'
    end
  end

  scope module: :administration do
    resources :accounts
    resources :currencies, except: :destroy
    resources :fiscal_years, except: :destroy
    resources :terms_of_payments, except: :destroy
    resources :printers
    resources :sum_levels
    resources :cash_registers
    resources :packages do
      get 'edit_keyword'
      get 'new_keyword'
      post 'update_keyword'
      post 'create_keyword'
      get 'edit_package_code'
      get 'new_package_code'
      post 'update_package_code'
      post 'create_package_code'
    end
  end

  scope module: :utilities do
    get 'qr_codes/generate'
  end

  get 'packages/:id/edit_keyword/:keyword_id', to: 'packages#edit_keyword'
  get 'packages/:id/new_keyword/', to: 'packages#new_keyword'
  post 'update_keyword/:keyword_id/:id', to: 'packages#update_keyword'
  post 'create_keyword/:id', to: 'packages#create_keyword'

  get 'packages/:id/edit_package_code/:package_code_id', to: 'packages#edit_package_code'
  get 'packages/:id/new_package_code/', to: 'packages#new_package_code'
  post 'update_package_code/:package_code_id/:id', to: 'packages#update_package_code'
  post 'create_package_code/:id', to: 'packages#create_package_code'

  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
