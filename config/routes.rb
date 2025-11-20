Rails.application.routes.draw do
  resources :authors
  resources :books

  root "authors#index"
end
