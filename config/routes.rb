Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }


  resources :organizations do
    member do
      get :analytics
      get 'space', to: 'space#show', as: :space
    end
    resources :memberships do
      member do
        get :accept
      end
    end

    resources :content_spaces do
      resources :contents, except: %i[index show]
    end
  end

  resources :parental_consents, only: %i[new create]
  get  '/parental_consents/:token/edit',   to: 'parental_consents#edit',   as: :edit_parental_consent
  patch '/parental_consents/:token',       to: 'parental_consents#update', as: :parental_consent

  resource :consents, only: [:create] do
    get 'approve', on: :collection
  end


  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "organizations#index"
end
