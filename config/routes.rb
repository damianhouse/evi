Rails.application.routes.draw do
  get 'general/welcome'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :patients
  resources :appointments
  devise_for :users

  root 'appointments#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
