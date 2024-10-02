Rails.application.routes.draw do
  root "rallies#index"
  resources :rallies, only: :index
end
