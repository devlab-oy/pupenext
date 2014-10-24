require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios/resque/email', to: 'monitoring#nagios_resque_email'

  resources :currencies, except: :destroy
  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
