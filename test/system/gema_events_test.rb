require "application_system_test_case"

class GemaEventsTest < ApplicationSystemTestCase
  setup do
    @gema_event = gema_events(:one)
  end

  test "visiting the index" do
    visit gema_events_url
    assert_selector "h1", text: "Gema events"
  end

  test "should create gema event" do
    visit gema_events_url
    click_on "New gema event"

    fill_in "Admission price", with: @gema_event.admission_price
    fill_in "Cultural reduction", with: @gema_event.cultural_reduction
    fill_in "Description", with: @gema_event.description
    fill_in "E reduction", with: @gema_event.e_reduction
    fill_in "Event date", with: @gema_event.event_date
    fill_in "Gema amount", with: @gema_event.gema_amount
    fill_in "Gstv reduction", with: @gema_event.gstv_reduction
    fill_in "Kdnr", with: @gema_event.kdnr
    fill_in "License nr", with: @gema_event.license_nr
    fill_in "Location", with: @gema_event.location
    fill_in "Music effort", with: @gema_event.music_effort
    fill_in "Name", with: @gema_event.name
    fill_in "Netto", with: @gema_event.netto
    fill_in "Orchestra", with: @gema_event.orchestra_id
    fill_in "Room size", with: @gema_event.room_size
    fill_in "Sap nr", with: @gema_event.sap_nr
    fill_in "Setlist", with: @gema_event.setlist
    fill_in "Tariff", with: @gema_event.tariff
    fill_in "Ticket total", with: @gema_event.ticket_total
    fill_in "Visitors", with: @gema_event.visitors
    click_on "Create Gema event"

    assert_text "Gema event was successfully created"
    click_on "Back"
  end

  test "should update Gema event" do
    visit gema_event_url(@gema_event)
    click_on "Edit this gema event", match: :first

    fill_in "Admission price", with: @gema_event.admission_price
    fill_in "Cultural reduction", with: @gema_event.cultural_reduction
    fill_in "Description", with: @gema_event.description
    fill_in "E reduction", with: @gema_event.e_reduction
    fill_in "Event date", with: @gema_event.event_date
    fill_in "Gema amount", with: @gema_event.gema_amount
    fill_in "Gstv reduction", with: @gema_event.gstv_reduction
    fill_in "Kdnr", with: @gema_event.kdnr
    fill_in "License nr", with: @gema_event.license_nr
    fill_in "Location", with: @gema_event.location
    fill_in "Music effort", with: @gema_event.music_effort
    fill_in "Name", with: @gema_event.name
    fill_in "Netto", with: @gema_event.netto
    fill_in "Orchestra", with: @gema_event.orchestra_id
    fill_in "Room size", with: @gema_event.room_size
    fill_in "Sap nr", with: @gema_event.sap_nr
    fill_in "Setlist", with: @gema_event.setlist
    fill_in "Tariff", with: @gema_event.tariff
    fill_in "Ticket total", with: @gema_event.ticket_total
    fill_in "Visitors", with: @gema_event.visitors
    click_on "Update Gema event"

    assert_text "Gema event was successfully updated"
    click_on "Back"
  end

  test "should destroy Gema event" do
    visit gema_event_url(@gema_event)
    click_on "Destroy this gema event", match: :first

    assert_text "Gema event was successfully destroyed"
  end
end
