require "test_helper"

class GemaEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gema_event = gema_events(:one)
  end

  test "should get index" do
    get gema_events_url
    assert_response :success
  end

  test "should get new" do
    get new_gema_event_url
    assert_response :success
  end

  test "should create gema_event" do
    assert_difference("GemaEvent.count") do
      post gema_events_url, params: { gema_event: { admission_price: @gema_event.admission_price, cultural_reduction: @gema_event.cultural_reduction, description: @gema_event.description, e_reduction: @gema_event.e_reduction, event_date: @gema_event.event_date, gema_amount: @gema_event.gema_amount, gstv_reduction: @gema_event.gstv_reduction, kdnr: @gema_event.kdnr, license_nr: @gema_event.license_nr, location: @gema_event.location, music_effort: @gema_event.music_effort, name: @gema_event.name, netto: @gema_event.netto, orchestra_id: @gema_event.orchestra_id, room_size: @gema_event.room_size, sap_nr: @gema_event.sap_nr, setlist: @gema_event.setlist, tariff: @gema_event.tariff, ticket_total: @gema_event.ticket_total, visitors: @gema_event.visitors } }
    end

    assert_redirected_to gema_event_url(GemaEvent.last)
  end

  test "should show gema_event" do
    get gema_event_url(@gema_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_gema_event_url(@gema_event)
    assert_response :success
  end

  test "should update gema_event" do
    patch gema_event_url(@gema_event), params: { gema_event: { admission_price: @gema_event.admission_price, cultural_reduction: @gema_event.cultural_reduction, description: @gema_event.description, e_reduction: @gema_event.e_reduction, event_date: @gema_event.event_date, gema_amount: @gema_event.gema_amount, gstv_reduction: @gema_event.gstv_reduction, kdnr: @gema_event.kdnr, license_nr: @gema_event.license_nr, location: @gema_event.location, music_effort: @gema_event.music_effort, name: @gema_event.name, netto: @gema_event.netto, orchestra_id: @gema_event.orchestra_id, room_size: @gema_event.room_size, sap_nr: @gema_event.sap_nr, setlist: @gema_event.setlist, tariff: @gema_event.tariff, ticket_total: @gema_event.ticket_total, visitors: @gema_event.visitors } }
    assert_redirected_to gema_event_url(@gema_event)
  end

  test "should destroy gema_event" do
    assert_difference("GemaEvent.count", -1) do
      delete gema_event_url(@gema_event)
    end

    assert_redirected_to gema_events_url
  end
end
