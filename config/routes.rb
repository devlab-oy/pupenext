require 'resque_web'

Pupesoft::Application.routes.draw do
  root to: 'home#index'

  mount ResqueWeb::Engine => "/resque"
end
