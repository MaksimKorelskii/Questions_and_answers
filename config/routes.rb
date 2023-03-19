Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  
  devise_for :users
  
  resources :awards, only: :index
  resources :links, only: :destroy
  resources :attachments, only: :destroy

  concern :rated do
    member do
      patch :uprate
      patch :downrate
      delete :cancel
    end
  end

  resources :questions, only: %i[ index new create show destroy update ], concerns: :rated do
    resources :answers, shallow: true, only: %i[ new create show destroy update ], concerns: :rated do
      patch :mark_as_best, on: :member
    end
  end
end
