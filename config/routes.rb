require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq' # энджайн - встраиваемое приложение в наше приложение
  end
  
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  get :search, to: 'search#index'
  
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  
  resources :awards, only: :index
  resources :links, only: :destroy
  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[ index ] do
        get :me, on: :collection
      end

      resources :questions, only: %i[ index show create update destroy] do
        resources :answers, shallow: true, only: %i[ index show create update destroy ]
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

    resources :subscriptions, shallow: true, only: %i[ create destroy ]
  end
end
