class RegistrationsController < Devise::RegistrationsController
    respond_to :json, :js
    prepend_before_filter :require_no_authentication, only: [:cancel ]

end
