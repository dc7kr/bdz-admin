require "test_helper"

class OrchestrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orchestra = orchestras(:one)
  end

  test "should get index" do
    get orchestras_url
    assert_response :success
  end

  test "should get new" do
    get new_orchestra_url
    assert_response :success
  end

  test "should create orchestra" do
    assert_difference("Orchestra.count") do
      post orchestras_url, params: { orchestra: {} }
    end

    assert_redirected_to orchestra_url(Orchestra.last)
  end

  test "should show orchestra" do
    get orchestra_url(@orchestra)
    assert_response :success
  end

  test "should get edit" do
    get edit_orchestra_url(@orchestra)
    assert_response :success
  end

  test "should update orchestra" do
    patch orchestra_url(@orchestra), params: { orchestra: {} }
    assert_redirected_to orchestra_url(@orchestra)
  end

  test "should destroy orchestra" do
    assert_difference("Orchestra.count", -1) do
      delete orchestra_url(@orchestra)
    end

    assert_redirected_to orchestras_url
  end
end
