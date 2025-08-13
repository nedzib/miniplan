Rails.application.routes.draw do
  get "invitations/index"
  get "invitations/edit"
  get "invitations/delete"
  get "landing/index"
  get "rsvp/confirm"
  get "rsvp/partial/:name", to: "rsvp#partial"
  get "events/index"
  get "events/show"
  resource :session
  resources :invitations do
    patch :rsvp, to: "rsvp#update"
  end
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  #
  root "landing#index"
end
