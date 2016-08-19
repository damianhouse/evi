Rails.application.routes.draw do
  get 'general/welcome'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :patients
  resources :appointments
  devise_for :users

  root 'appointments#index'

  # AJAX pages

  get 'close_all' => 'appointments#close_all'

end
