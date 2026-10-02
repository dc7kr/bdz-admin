require "test_helper"

class FestivalExhibitorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @festival_exhibitor = FestivalExhibitor.create!(
      # with a special tariff the pages don't build an invoice, which needs MongoDB
      year: 2026, tariff: 1, special_tariff: 1, special_amount: 50, contact: Contact.new(
      subtype: "", salutation: "Herr", first_name: "Max", last_name: "Aussteller",
      street: "Hauptstr. 1", zip: "12345", city: "Musterstadt", country_code: "DE"
    ))
  end

  test "national user can list, show, create and edit exhibitors" do
    sign_in create_user(:national)

    get festival_exhibitors_url
    assert_response :success

    get festival_exhibitor_url(@festival_exhibitor)
    assert_response :success

    get new_festival_exhibitor_url
    assert_response :success

    get edit_festival_exhibitor_url(@festival_exhibitor)
    assert_response :success
  end

  test "national user can update an exhibitor" do
    sign_in create_user(:national)

    patch festival_exhibitor_url(@festival_exhibitor), params: { festival_exhibitor: { special_amount: 42 } }
    assert_redirected_to festival_exhibitor_url(@festival_exhibitor)
    assert_equal 42, @festival_exhibitor.reload.special_amount
  end

  test "festival user can show but not edit an exhibitor" do
    sign_in create_user(:festival)

    get festival_exhibitor_url(@festival_exhibitor)
    assert_response :success

    get edit_festival_exhibitor_url(@festival_exhibitor)
    assert_redirected_to root_url
  end

  test "exhibitors may not be destroyed" do
    sign_in create_user(:admin)

    assert_no_difference("FestivalExhibitor.count") do
      delete festival_exhibitor_url(@festival_exhibitor)
    end
    assert_redirected_to root_url
  end
end
