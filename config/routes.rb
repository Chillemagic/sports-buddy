Rails.application.routes.draw do
  get "pages/home"
  resources :chats do
    resources :messages, only: %i[create]
  end
  resources :models, only: %i[index show] do
    collection do
      post :refresh
    end
  end

  resources :game_teams do
    resources :game_team_users, only: %i[create destroy]
  end

  resources :games

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :users, only: %i[show edit update]
  get "dashboard", to: "users#dashboard"
  get "preferences", to: "users#preferences"
  get "matches", to: "users#matches"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "users#dashboard"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
