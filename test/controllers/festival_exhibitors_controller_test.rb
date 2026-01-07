require "test_helper"

class FestivalExhibitorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @festival_exhibitor = festival_exhibitors(:one)
  end

  test "should get index" do
    get festival_exhibitors_url
    assert_response :success
  end

  test "should get new" do
    get new_festival_exhibitor_url
    assert_response :success
  end

  test "should create festival_exhibitor" do
    assert_difference("FestivalExhibitor.count") do
      post festival_exhibitors_url, params: { festival_exhibitor: { special_amount: @festival_exhibitor.special_amount, special_tariff: @festival_exhibitor.special_tariff, tariff: @festival_exhibitor.tariff, year: @festival_exhibitor.year } }
    end

    assert_redirected_to festival_exhibitor_url(FestivalExhibitor.last)
  end

  test "should show festival_exhibitor" do
    get festival_exhibitor_url(@festival_exhibitor)
    assert_response :success
  end

  test "should get edit" do
    get edit_festival_exhibitor_url(@festival_exhibitor)
    assert_response :success
  end

  test "should update festival_exhibitor" do
    patch festival_exhibitor_url(@festival_exhibitor), params: { festival_exhibitor: { special_amount: @festival_exhibitor.special_amount, special_tariff: @festival_exhibitor.special_tariff, tariff: @festival_exhibitor.tariff, year: @festival_exhibitor.year } }
    assert_redirected_to festival_exhibitor_url(@festival_exhibitor)
  end

  test "should destroy festival_exhibitor" do
    assert_difference("FestivalExhibitor.count", -1) do
      delete festival_exhibitor_url(@festival_exhibitor)
    end

    assert_redirected_to festival_exhibitors_url
  end
end
