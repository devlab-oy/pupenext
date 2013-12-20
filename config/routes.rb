Pupesoft::Application.routes.draw do
  resources :currencies
  root to: 'home#index'
end
