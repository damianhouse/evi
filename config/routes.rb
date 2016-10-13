Rails.application.routes.draw do
  resources :invoices
  get 'general/welcome'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :patients
  resources :appointments

  devise_for :users, :controllers => {registrations: 'registrations'}

  root 'appointments#index'
  get 'paid' => 'invoices#paid'
  get 'sort_invoices' => 'invoices#sort_invoices'
  post 'sort_invoices' => 'invoices#sort_invoices'
  get 'sort_appointments' => 'appointments#sort_appointments'
  post 'sort_appointments' => 'appointments#sort_appointments'

  # AJAX pages
  get 'close_all' => 'appointments#close_all'
  get 'all_appointments' => 'appointments#all_appointments'

end
