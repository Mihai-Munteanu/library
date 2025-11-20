Rails.application.routes.draw do
  resources :members
  resources :authors
  resources :books

  root "authors#index"
end
