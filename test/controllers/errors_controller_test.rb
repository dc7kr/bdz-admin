require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get not_found" do
    get errors_404_url
    assert_response :success
  end

  test "should get internal_server_error" do
    get errors_500_url
    assert_response :success
  end
end
