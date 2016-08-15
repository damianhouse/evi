require 'test_helper'

class GeneralControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    get general_welcome_url
    assert_response :success
  end

end
