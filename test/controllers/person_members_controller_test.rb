require "test_helper"

class PersonMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @region = create_regional_organization(91)
    @other_region = create_regional_organization(92)
    tariff = Tariff.create!(tariff_type: "P", description: "Einzelmitglied", amount: 10)
    @person_member = PersonMember.create!(tariff: tariff, member_attributes: member_attributes("91501", @region))
    @other_person_member = PersonMember.create!(tariff: tariff, member_attributes: member_attributes("92501", @other_region))
  end

  test "admin can list, show, create and edit person members" do
    sign_in create_user(:admin)

    get person_members_url
    assert_response :success

    get person_member_url(@person_member)
    assert_response :success

    get new_person_member_url
    assert_response :success

    get edit_person_member_url(@person_member)
    assert_response :success
  end

  test "regional user only sees person members of its regional organization" do
    sign_in create_user(restricting_entity: @region)

    get person_member_url(@person_member)
    assert_response :success

    get person_member_url(@other_person_member)
    assert_response :not_found
  end

  test "regional user may not edit person members" do
    sign_in create_user(restricting_entity: @region)

    get edit_person_member_url(@person_member)
    assert_redirected_to root_url
  end
end
