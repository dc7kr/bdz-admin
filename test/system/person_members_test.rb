require "application_system_test_case"

class PersonMembersTest < ApplicationSystemTestCase
  setup do
    @person_member = person_members(:one)
  end

  test "visiting the index" do
    visit person_members_url
    assert_selector "h1", text: "Person members"
  end

  test "should create person member" do
    visit person_members_url
    click_on "New person member"

    click_on "Create Person member"

    assert_text "Person member was successfully created"
    click_on "Back"
  end

  test "should update Person member" do
    visit person_member_url(@person_member)
    click_on "Edit this person member", match: :first

    click_on "Update Person member"

    assert_text "Person member was successfully updated"
    click_on "Back"
  end

  test "should destroy Person member" do
    visit person_member_url(@person_member)
    click_on "Destroy this person member", match: :first

    assert_text "Person member was successfully destroyed"
  end
end
