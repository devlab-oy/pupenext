require 'resque_web'

Pupesoft::Application.routes.draw do
  get 'monitoring/nagios'

  resources :currencies, except: :destroy
  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
