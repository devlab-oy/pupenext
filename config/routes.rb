require 'resque_web'

Pupesoft::Application.routes.draw do
  root to: 'home#index'
  get '/test', to: 'home#test'

  mount ResqueWeb::Engine => "/resque"
end
