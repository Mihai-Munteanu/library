Rails.application.routes.draw do
  get "dashboard/index"
  resources :loans
  resources :members
  resources :authors
  resources :books

  root "dashboard#index"
end
