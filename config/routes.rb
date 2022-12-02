Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions, only: [:create]
      resource :points, only: [:update]
      resources :points, only: [:index]
    end
  end
end
