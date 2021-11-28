Rails.application.routes.draw do
  resources :questions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#index'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions, except: [:show, :new, :index]

  get 'sign_up', to: 'users#new'
  get 'log_out', to: 'sessions#destroy'
  get 'log_in', to: 'sessions#new'
end
