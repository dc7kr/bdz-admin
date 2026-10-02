require "test_helper"

# GemaEvent is a Mongoid document; these tests need the MongoDB configured for the
# test environment in config/mongoid.yml and are skipped without it.
class GemaEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    skip "MongoDB for the test environment is not available" unless mongodb_available?

    @gema_event = GemaEvent.create!(name: "Frühjahrskonzert", event_date: Date.new(2026, 4, 1), location: "Stadthalle")
    sign_in create_user(:national)
  end

  teardown do
    GemaEvent.delete_all if mongodb_available?
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
      post gema_events_url, params: { gema_event: { name: "Herbstkonzert", event_date: "2026-10-01" } }
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
    patch gema_event_url(@gema_event), params: { gema_event: { location: "Kirche" } }
    assert_redirected_to gema_event_url(@gema_event)
    assert_equal "Kirche", @gema_event.reload.location
  end

  test "should destroy gema_event" do
    assert_difference("GemaEvent.count", -1) do
      delete gema_event_url(@gema_event)
    end

    assert_redirected_to gema_events_url
  end

  # checked once per test run
  def self.mongodb_available?
    return @mongodb_available if defined?(@mongodb_available)

    @mongodb_available = begin
      Mongoid.default_client.with(server_selection_timeout: 1).database.command(ping: 1)
      true
    rescue Mongo::Error
      false
    end
  end

  private

  def mongodb_available? = self.class.mongodb_available?
end

# runs without MongoDB: requests are rejected before any event is loaded
class GemaEventsAuthenticationTest < ActionDispatch::IntegrationTest
  test "requires a signed in user" do
    get gema_events_url
    assert_redirected_to new_user_session_url

    post gema_events_url, params: { gema_event: { name: "Herbstkonzert" } }
    assert_redirected_to new_user_session_url

    delete gema_event_url("0123456789abcdef01234567")
    assert_redirected_to new_user_session_url
  end

  test "member area requires a signed in user" do
    get mgl_gema_events_url
    assert_redirected_to new_user_session_url
  end
end
