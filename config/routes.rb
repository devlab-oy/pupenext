require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'
  get 'monitoring/nagios/resque/failed', to: 'monitoring#nagios_resque_failed'

  get 'pending_product_updates/list', to: 'pending_product_updates#list'
  get 'pending_product_updates/list_of_changes', to: 'pending_product_updates#list_of_changes'
  get 'pending_product_updates/gallery/:id', to: 'pending_product_updates#gallery'
  post 'pending_product_updates/to_product', to: 'pending_product_updates#to_product'
  resources :pending_product_updates

  resources :supplier_product_informations, only: :index do
    collection do
      post :transfer
    end
  end

  resources :customers, only: [:create, :update] do
    collection do
      get 'find_by_email'
    end
  end

  scope module: :fixed_assets do
    resources :commodities, except: :destroy do
      get :purchase_orders
      get :sell
      get :vouchers
      post :activate
      post :confirm_sale
      post :generate_rows
      post :delete_rows
      post :destroy_commodity
      post :link_order
      post :link_voucher
      post :unlink
    end
  end

  scope module: :administration do
    resources :accounts
    resources :bank_accounts
    resources :bank_details, except: :destroy
    resources :campaigns, except: :destroy
    resources :carriers
    resources :cash_registers
    resources :cash_registers
    resources :companies, only: [] do
      collection do
        post :copy
      end
    end
    resources :currencies, except: :destroy
    resources :custom_attributes
    resources :customer_transports
    resources :fiscal_years, except: :destroy
    resources :incoming_mails, only: :index
    resources :mail_servers
    resources :packages
    resources :packing_areas
    resources :printers
    resources :products
    resources :qualifier_cost_centers, path: :qualifiers, controller: :qualifiers
    resources :qualifier_projects,     path: :qualifiers, controller: :qualifiers
    resources :qualifier_targets,      path: :qualifiers, controller: :qualifiers
    resources :qualifiers
    resources :revenue_expenditures
    resources :sum_level_commodities, path: :sum_levels, controller: :sum_levels
    resources :sum_level_externals,   path: :sum_levels, controller: :sum_levels
    resources :sum_level_internals,   path: :sum_levels, controller: :sum_levels
    resources :sum_level_profits,     path: :sum_levels, controller: :sum_levels
    resources :sum_level_vats,        path: :sum_levels, controller: :sum_levels
    resources :sum_levels
    resources :terms_of_payments, except: :destroy
    resources :transports
  end

  get :downloads, to: 'downloads#index'
  get 'downloads/:id', to: 'downloads#show', as: :download_file
  delete 'downloads/:id', to: 'downloads#destroy', as: :download

  scope module: :utilities do
    get 'qr_codes/generate'
    get 'logs', to: 'logs#index'
    get 'logs/show/:name', to: 'logs#show', as: :show_log
    get 'woo/complete_order', to: 'woo#complete_order', as: :complete_order
  end

  scope module: :reports do
    get :revenue_expenditure,         to: 'revenue_expenditure#index',  as: :revenue_expenditure_report
    get :stock_listing_csv,           to: 'stock_listing_csv#index',    as: :stock_listing_csv
    post :stock_listing_csv,          to: 'stock_listing_csv#run',      as: :run_stock_listing_csv
    get :stock_availability,          to: 'stock_availability#index',   as: :stock_availability
    get :run_stock_availability,      to: 'stock_availability#run',     as: :run_stock_availability
    get :view_connected_sales_orders, to: 'stock_availability#view_connected_sales_orders'
    get :full_installments,           to: 'full_installments#index',    as: :full_installments
    post :full_installments,          to: 'full_installments#run',      as: :run_full_installments
    get :product_stock_pdf,           to: 'product_stock_pdf#index',    as: :product_stock_pdf_index
    post :product_stock_pdf,          to: 'product_stock_pdf#find',     as: :product_stock_pdf_find
    get 'product_stock_pdf/:qty/:id', to: 'product_stock_pdf#show',     as: :product_stock_pdf

    resources :commodity_balance_sheet, only: [:index, :create]
    resources :commodity_financial_statements, only: [:index, :create]
    resources :customer_price_lists, only: [:index, :create]
    resources :depreciation_difference, only: [:index, :create]
  end

  scope :data_export do
    get  '/', to: redirect('/data_export/product_keywords') # temporary placeholder
    get  :product_keywords, to: 'data_export#product_keywords', as: :product_keyword_export
    post :product_keywords, to: 'data_export#product_keywords_generate'
  end

  scope :data_import do
    get  '/',                     to: 'data_import#index',                 as: :data_import
    post :customer_sales,         to: 'data_import#customer_sales',        as: :customer_sales_import
    post :destroy_customer_sales, to: 'data_import#destroy_customer_sales', as: :destroy_customer_sales_import
    post :product_information,    to: 'data_import#product_information',   as: :product_information_import
    post :product_keywords,       to: 'data_import#product_keywords',      as: :product_keyword_import
  end

  scope module: :category do
    resources :product_categories, only: [:index, :show] do
      collection do
        get :tree
        get :roots
      end

      member do
        get :breadcrumbs
        get :children
        get :products
      end
    end
  end

  resources :products, only: [] do
    get :stock_available_per_warehouse, to: 'stocks#stock_available_per_warehouse'
  end

  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
