require 'test_helper'

class GemaEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gema_event = gema_events(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:gema_events)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create gema_event' do
    assert_difference('GemaEvent.count') do
      post :create, params: { gema_event: { amount: @gema_event.amount, city: @gema_event.city, date: @gema_event.date, kdnr: @gema_event.kdnr,
                                            location: @gema_event.location, location_city: @gema_event.location_city, name: @gema_event.name, nf_id: @gema_event.nf_id, par_mgl: @gema_event.par_mgl, program_available: @gema_event.program_available, source: @gema_event.source, tariff: @gema_event.tariff, title: @gema_event.title, zip: @gema_event.zip } }
    end

    assert_redirected_to gema_event_path(assigns(:gema_event))
  end

  test 'should show gema_event' do
    get :show, params: { id: @gema_event }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @gema_event }
    assert_response :success
  end

  test 'should update gema_event' do
    patch :update, params: { id: @gema_event, gema_event: { amount: @gema_event.amount, city: @gema_event.city, date: @gema_event.date, kdnr: @gema_event.kdnr, location: @gema_event.location, location_city: @gema_event.location_city, name: @gema_event.name, nf_id: @gema_event.nf_id, par_mgl: @gema_event.par_mgl, program_available: @gema_event.program_available, source: @gema_event.source, tariff: @gema_event.tariff, title: @gema_event.title, zip: @gema_event.zip } }
    assert_redirected_to gema_event_path(assigns(:gema_event))
  end

  test 'should destroy gema_event' do
    assert_difference('GemaEvent.count', -1) do
      delete :destroy, params: { id: @gema_event }
    end

    assert_redirected_to gema_events_path
  end
end
