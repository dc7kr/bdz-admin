module Mgl
  # read only
  class GemaEventsController < BaseController
    def index
      authorize GemaEvent
      @gema_events = policy_scope(GemaEvent).order(event_date: :desc)
    end

    def show
      # mongoid may be configured not to raise (raise_not_found_error: false)
      @gema_event = policy_scope(GemaEvent).find(params[:id]) or
        raise Mongoid::Errors::DocumentNotFound.new(GemaEvent, params[:id])
      authorize @gema_event
    end
  end
end
