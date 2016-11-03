class RegistrationsController < Devise::RegistrationsController
    respond_to :json, :js
    prepend_before_action :require_no_authentication, only: [:cancel ]

    protected

    def sign_up(resource_name, resource)
      sign_in(resource_name, resource) unless current_user
    end
end
