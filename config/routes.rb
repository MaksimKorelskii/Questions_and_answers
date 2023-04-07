Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  
  resources :awards, only: :index
  resources :links, only: :destroy
  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
      end
    end
  end

  concern :rated do
    member do
      patch :uprate
      patch :downrate
      delete :cancel
    end
  end

  resources :questions, only: %i[ index new create show destroy update ], concerns: :rated do
    resources :comments, only: :create, context: 'Question', on: :member

    resources :answers, shallow: true, only: %i[ new create show destroy update ], concerns: :rated do
      patch :mark_as_best, on: :member
      resources :comments, only: :create, context: 'Answer', on: :member
    end
  end
end
