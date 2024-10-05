Rails.application.routes.draw do
  devise_for :users
  
  root "rallies#index"
  resources :rallies, only: [:index, :new, :show]
end
