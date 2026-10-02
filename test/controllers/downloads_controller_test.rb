require "test_helper"

class DownloadsControllerTest < ActionDispatch::IntegrationTest
  test "national user gets 404 for a missing archive file" do
    sign_in create_user(:national)

    get dl_url(year: "1900", filename: "missing", format: "pdf")
    assert_response :not_found
  end

  test "user without national permission may not download" do
    sign_in create_user

    get dl_url(year: "1900", filename: "missing", format: "pdf")
    assert_redirected_to root_url
  end
end
