class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def is_authorized?
     if current_user == @user
       true
     elsif current_user.admin
       true
     else
       false
     end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :phone_number, :hourly_rate, :mileage_rate])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :email, :hourly_rate, :mileage_rate ])
  end
end
