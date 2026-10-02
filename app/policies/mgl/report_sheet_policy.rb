# frozen_string_literal: true

module Mgl
  # Report sheets may be changed until they have been invoiced. Sheets of past
  # years are closed as well, older ones were invoiced before invoices were
  # booked in this application.
  class ReportSheetPolicy < OrchestraDataPolicy
    def update?
      own? && !record.locked? && record.year >= Time.zone.today.year
    end
  end
end
