Rails.application.routes.draw do
  resources :invoices
  get 'general/welcome'

  resources :patients
  resources :appointments

  devise_for :users, :controllers => {registrations: 'registrations'}
  devise_scope :user do
   get "/registrations/index" => 'registrations#index'
  end
  resources :users

  root 'appointments#index'
  get 'destroy_appointment' => 'appointments#destroy'
  get 'paid' => 'invoices#paid'
  get 'unpaid' => 'invoices#unpaid'
  get 'paid_list' => 'invoices#paid_list'
  get 'unpaid_list' => 'invoices#unpaid_list'
  get 'sort_invoices' => 'invoices#sort_invoices'
  post 'sort_invoices' => 'invoices#sort_invoices'
  get 'sort_appointments' => 'appointments#sort_appointments'
  post 'sort_appointments' => 'appointments#sort_appointments'
  get 'sort_appointments_list' => 'appointments#sort_appointments_list'
  post 'sort_appointments_list' => 'appointments#sort_appointments_list'
  get 'auto_create' => 'invoices#auto_create'
  get 'destroy_invoice' => 'invoices#destroy'
  # AJAX pages
  get 'all_appointments' => 'appointments#all_appointments'

end
