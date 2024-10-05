Rails.application.routes.draw do
  devise_for :users
  
  root "rallies#index"
  resources :rallies
  resources :users, only: :show
end
