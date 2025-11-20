Rails.application.routes.draw do
  resources :loans
  resources :members
  resources :authors
  resources :books

  root "authors#index"
end
