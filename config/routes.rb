Rails.application.routes.draw do
  get "dashboard/index"
  resources :loans do
    member do
      get :delete_confirmation
    end
  end
  resources :members do
    member do
      get :delete_confirmation
    end
  end
  resources :authors do
    member do
      get :delete_confirmation
    end
  end
  resources :books do
    member do
      get :delete_confirmation
    end
  end

  root "dashboard#index"

  # Catch all unmatched routes and return 404
  match "*path", to: "application#routing_error", via: :all, constraints: ->(req) { !req.path.start_with?("/rails") }
end
