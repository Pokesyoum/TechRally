Rails.application.routes.draw do
  devise_for :users
  
  root "rallies#index"
  resources :rallies do
    resources :comments, only: :create
  end
  resources :users, only: :show
  resources :look_for_papers, only: [:show, :create]
end
