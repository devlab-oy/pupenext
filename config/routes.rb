require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'
  get 'monitoring/nagios/resque/failed', to: 'monitoring#nagios_resque_failed'

  resources :currencies, except: :destroy

  namespace :accounting do
    namespace :fixed_assets do
      get '/commodities/:id/select_purchase_order(.:format)',
        to: 'commodities#select_purchase_order', as: 'commodities_purchase_orders'
      get '/commodities/:id/select_voucher',
        to: 'commodities#select_voucher',as: 'commodities_vouchers'
      get '/commodities/fiscal_year_run',
        to: 'commodities#fiscal_year_run',as: 'fiscal_year_run'
      resources :commodities, except: :destroy
    end
  end

  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
