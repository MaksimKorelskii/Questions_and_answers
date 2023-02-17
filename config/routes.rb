Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#show"
  
  devise_for :users

  resources :questions, only: %i[ new create show ] do
    resources :answers, shallow: true, only: %i[ new create show ]
  end
end
