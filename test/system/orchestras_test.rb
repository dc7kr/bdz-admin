require "application_system_test_case"

class OrchestrasTest < ApplicationSystemTestCase
  setup do
    @orchestra = orchestras(:one)
  end

  test "visiting the index" do
    visit orchestras_url
    assert_selector "h1", text: "Orchestras"
  end

  test "should create orchestra" do
    visit orchestras_url
    click_on "New orchestra"

    click_on "Create Orchestra"

    assert_text "Orchestra was successfully created"
    click_on "Back"
  end

  test "should update Orchestra" do
    visit orchestra_url(@orchestra)
    click_on "Edit this orchestra", match: :first

    click_on "Update Orchestra"

    assert_text "Orchestra was successfully updated"
    click_on "Back"
  end

  test "should destroy Orchestra" do
    visit orchestra_url(@orchestra)
    click_on "Destroy this orchestra", match: :first

    assert_text "Orchestra was successfully destroyed"
  end
end
