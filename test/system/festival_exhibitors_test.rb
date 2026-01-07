require "application_system_test_case"

class FestivalExhibitorsTest < ApplicationSystemTestCase
  setup do
    @festival_exhibitor = festival_exhibitors(:one)
  end

  test "visiting the index" do
    visit festival_exhibitors_url
    assert_selector "h1", text: "Festival exhibitors"
  end

  test "should create festival exhibitor" do
    visit festival_exhibitors_url
    click_on "New festival exhibitor"

    fill_in "Special amount", with: @festival_exhibitor.special_amount
    check "Special tariff" if @festival_exhibitor.special_tariff
    fill_in "Tariff", with: @festival_exhibitor.tariff
    fill_in "Year", with: @festival_exhibitor.year
    click_on "Create Festival exhibitor"

    assert_text "Festival exhibitor was successfully created"
    click_on "Back"
  end

  test "should update Festival exhibitor" do
    visit festival_exhibitor_url(@festival_exhibitor)
    click_on "Edit this festival exhibitor", match: :first

    fill_in "Special amount", with: @festival_exhibitor.special_amount
    check "Special tariff" if @festival_exhibitor.special_tariff
    fill_in "Tariff", with: @festival_exhibitor.tariff
    fill_in "Year", with: @festival_exhibitor.year
    click_on "Update Festival exhibitor"

    assert_text "Festival exhibitor was successfully updated"
    click_on "Back"
  end

  test "should destroy Festival exhibitor" do
    visit festival_exhibitor_url(@festival_exhibitor)
    click_on "Destroy this festival exhibitor", match: :first

    assert_text "Festival exhibitor was successfully destroyed"
  end
end
