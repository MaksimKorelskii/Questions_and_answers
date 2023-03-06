Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#index"
  
  devise_for :users

  resources :attachments, only: :destroy

  resources :questions, only: %i[ index new create show destroy update ] do
    resources :answers, shallow: true, only: %i[ new create show destroy update ] do
      patch :mark_as_best, on: :member
    end
  end
end
