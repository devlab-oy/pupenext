Pupesoft::Application.routes.draw do
  resources :accounts
  root to: 'home#index'
end
