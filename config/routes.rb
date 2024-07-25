require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  root "home#index"
  get "home/index"

  resources :linkedin_connections
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "home#health", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # help to write root path to import_csv#index
  post "import_csv/import_connections"
  resources :chats, only: %i[show] do
    resources :messages, only: %i[create]
  end
end
