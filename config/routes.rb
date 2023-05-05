Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'home#index'

  namespace :admin do
    resources :users
    root 'users#index'
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users do
        collection do
          get 'all'
          get :profile
          post 'profile/update', action: :update
          post :login
          post :register
        end
      end

      get '/*a', to: 'application#not_found'
    end
  end
end
