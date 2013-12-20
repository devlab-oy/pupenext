Pupesoft::Application.routes.draw do
  resources :currency
  root to: 'home#index'
end
