Rails.application.routes.draw do
  resources :authors

  root "authors#index"
end
