Rails.application.routes.draw do
  # Authentication
  devise_for :users

  # Organization management
  resources :organizations do
    # Future: nested memberships or dashboards can go here
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Progressive Web App assets (optional)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root route
  root "organizations#index"
end
