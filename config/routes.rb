ExperimentTracker::Application.routes.draw do
  
  root :to => "home#index"
  
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  
  devise_scope :user do
    get "/login" => "devise/sessions#new"
  end
  
  devise_scope :user do
    get "/logout" => "devise/sessions#destroy"
  end
  
  resources :oauth_consumers do
      member do
        get :callback
      end
  end
  
  resources :groups
  resources :subjects
  resources :slots do
    member do
      delete :cancel
    end
  
  end

  resources :experiments do
    collection do
  get :admin
  end
  
  
  end

  resources :locations
  resources :google_calendars
  resources :preview do
  
    member do
  post :markdown
  end
  
  end 

 match '/:controller(/:action(/:id))'
end
