Pupesoft::Application.routes.draw do
  resources :currencies, except: :destroy
  root to: 'home#index'
end
