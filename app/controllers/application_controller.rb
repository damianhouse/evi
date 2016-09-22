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
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit(:first_name, :last_name, :email, :password)
      end
    end
end
