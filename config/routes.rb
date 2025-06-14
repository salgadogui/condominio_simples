Rails.application.routes.draw do
  resources :charges
  resources :billings
  resources :apartments
  resources :blocks
  resources :buildings
  resource :session
  resources :passwords, param: :token
  resources :landlords, only: [ :index ]

  resources :contracts do
    collection do
      get :apartments
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
