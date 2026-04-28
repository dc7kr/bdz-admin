require "test_helper"

class PersonMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person_member = person_members(:one)
  end

  test "should get index" do
    get person_members_url
    assert_response :success
  end

  test "should get new" do
    get new_person_member_url
    assert_response :success
  end

  test "should create person_member" do
    assert_difference("PersonMember.count") do
      post person_members_url, params: { person_member: {} }
    end

    assert_redirected_to person_member_url(PersonMember.last)
  end

  test "should show person_member" do
    get person_member_url(@person_member)
    assert_response :success
  end

  test "should get edit" do
    get edit_person_member_url(@person_member)
    assert_response :success
  end

  test "should update person_member" do
    patch person_member_url(@person_member), params: { person_member: {} }
    assert_redirected_to person_member_url(@person_member)
  end

  test "should destroy person_member" do
    assert_difference("PersonMember.count", -1) do
      delete person_member_url(@person_member)
    end

    assert_redirected_to person_members_url
  end
end
