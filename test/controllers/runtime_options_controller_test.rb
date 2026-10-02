require "test_helper"

class RuntimeOptionsControllerTest < ActionDispatch::IntegrationTest
  setup { RuntimeOption.reload_cache }

  test "admin sets, resets and reloads options" do
    sign_in create_user(:admin)

    get runtime_options_url
    assert_response :success
    assert_select "code", "festival_year"

    get edit_runtime_option_url("festival_year")
    assert_response :success

    patch runtime_option_url("festival_year"), params: { runtime_option: { value: "2030" } }
    assert_redirected_to runtime_options_url
    assert_equal 2030, RuntimeOption.festival_year

    patch runtime_option_url("festival_year"), params: { runtime_option: { value: "" } }
    assert_response :unprocessable_entity

    patch runtime_option_url("presale_active"), params: { runtime_option: { value: "1" } }
    assert_equal true, RuntimeOption.presale_active

    delete runtime_option_url("festival_year")
    assert_redirected_to runtime_options_url
    assert_equal BDZ_SETTINGS["config"]["festival_year"], RuntimeOption.festival_year

    post reload_runtime_options_url
    assert_redirected_to runtime_options_url
  end

  test "unknown options are not found" do
    sign_in create_user(:admin)

    get edit_runtime_option_url("unknown")
    assert_response :not_found
  end

  test "other users are denied" do
    sign_in create_user(:national)

    get runtime_options_url
    assert_redirected_to root_url

    patch runtime_option_url("festival_year"), params: { runtime_option: { value: "2030" } }
    assert_redirected_to root_url
    assert_not RuntimeOption.exists?(key: "festival_year")
  end
end
