Rails.application.routes.draw do
  devise_for :users
  
  root "rallies#index"
  resources :rallies do
    resources :comments, only: :create
    collection do
      get :rally_lists
    end
  end
  resources :users, only: :show
  resources :look_for_papers, only: [:show, :create]
  resources :paper_stocks, only: [:show, :create]
end
