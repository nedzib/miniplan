Rails.application.routes.draw do
  resources :events do
    resources :presupuestos do
      resources :lineas, except: [ :show ]
    end
    resources :family_groups, only: [ :index, :create, :destroy ]
    resources :invitations, except: [ :show ] do
      collection do
        patch :reset_all
      end
    end
  end
  get "landing/index"
  get "rsvp/confirm/:hash_id", to: "rsvp#confirm", as: :rsvp_confirm
  get "rsvp/partial/:name", to: "rsvp#partial"
  resource :session
  resource :registration, only: [ :new, :create ]
  get "invitations_edit", to: "invitations#edit", as: :invitations_edit
  resources :invitations, only: [] do
    member do
      get :edit, param: :hash_id
      delete :destroy, param: :hash_id
      patch :update, param: :hash_id
    end
  end
  patch "invitations/:hash_id/rsvp", to: "rsvp#update", as: :invitation_rsvp_update
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
