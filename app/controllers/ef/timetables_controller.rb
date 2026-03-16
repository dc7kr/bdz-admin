module Ef
  class TimetablesController < Ef::ApplicationController
    include ::ApplicationHelper
    def stage_times
      @festival_applications = FestivalApplication.current_festival.permitted.order("orch_name")

    end
  end
end
