require "test_helper"

class OrchestrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @region = create_regional_organization(91)
    @other_region = create_regional_organization(92)
    @orchestra = Orchestra.create!(orchName: "Testorchester", orch_type: "O", member_attributes: member_attributes("91001", @region))
    @other_orchestra = Orchestra.create!(orchName: "Anderes Orchester", orch_type: "O", member_attributes: member_attributes("92001", @other_region))
  end

  test "admin can list, show, create and edit orchestras" do
    sign_in create_user(:admin)

    get orchestras_url
    assert_response :success

    get orchestra_url(@orchestra)
    assert_response :success

    get new_orchestra_url
    assert_response :success

    get edit_orchestra_url(@orchestra)
    assert_response :success
  end

  test "regional user only sees orchestras of its regional organization" do
    sign_in create_user(restricting_entity: @region)

    get orchestra_url(@orchestra)
    assert_response :success

    get orchestra_url(@other_orchestra)
    assert_response :not_found
  end

  test "regional user may not edit orchestras" do
    sign_in create_user(restricting_entity: @region)

    get edit_orchestra_url(@orchestra)
    assert_redirected_to root_url
  end
end
