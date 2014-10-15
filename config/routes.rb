require 'resque_web'

Pupesoft::Application.routes.draw do
  resources :currencies, except: :destroy
  root to: 'home#index'

  mount ResqueWeb::Engine => "/resque"
end
