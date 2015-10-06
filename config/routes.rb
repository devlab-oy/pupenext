require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'
  get 'monitoring/nagios/resque/failed', to: 'monitoring#nagios_resque_failed'

  get 'pending_product_updates/list', to: 'pending_product_updates#list'
  get 'pending_product_updates/list_of_changes', to: 'pending_product_updates#list_of_changes'
  post 'pending_product_updates/to_product', to: 'pending_product_updates#to_product'
  resources :pending_product_updates

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
    resources :bank_accounts
    resources :bank_details, except: :destroy
    resources :carriers
    resources :cash_registers
    resources :cash_registers
    resources :currencies, except: :destroy
    resources :custom_attributes
    resources :fiscal_years, except: :destroy
    resources :packages
    resources :packing_areas
    resources :printers
    resources :products
    resources :qualifier_cost_centers, path: :qualifiers, controller: :qualifiers
    resources :qualifier_projects, path: :qualifiers, controller: :qualifiers
    resources :qualifier_targets, path: :qualifiers, controller: :qualifiers
    resources :qualifiers
    resources :revenue_expenditures
    resources :sum_level_commodities, path: :sum_levels, controller: :sum_levels
    resources :sum_level_externals, path: :sum_levels, controller: :sum_levels
    resources :sum_level_internals, path: :sum_levels, controller: :sum_levels
    resources :sum_level_profits, path: :sum_levels, controller: :sum_levels
    resources :sum_level_vats, path: :sum_levels, controller: :sum_levels
    resources :sum_levels
    resources :terms_of_payments, except: :destroy
    resources :transports
  end

  get :downloads, to: 'downloads#index'
  get 'downloads/:id', to: 'downloads#show', as: :download_file
  delete 'downloads/:id', to: 'downloads#destroy', as: :download

  scope module: :utilities do
    get 'qr_codes/generate'
  end

  scope module: :reports do
    get :revenue_expenditure, to: 'revenue_expenditure#index', as: :revenue_expenditure_report
    get :stock_listing_csv,  to: 'stock_listing_csv#index', as: :stock_listing_csv
    post :stock_listing_csv, to: 'stock_listing_csv#run', as: :run_stock_listing_csv
    get :stock_availability, to: 'stock_availability#index', as: :stock_availability
    post :stock_availability, to: 'stock_availability#run', as: :run_stock_availability
  end

  scope :data_import do
    get '/', to: 'data_import#index', as: :data_import
    post :product_keywords,    to: 'data_import#product_keywords',    as: :product_keyword_import
    post :product_information, to: 'data_import#product_information', as: :product_information_import
  end

  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
