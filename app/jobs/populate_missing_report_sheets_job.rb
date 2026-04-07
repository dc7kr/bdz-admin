class PopulateMissingReportSheetsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false
  attr_accessor :generated

  after_perform do |job|
    year = job.arguments[0]
    if self.generated.length > 0
      User.for_admin_notify.each do |u|
        AdminNotifier.populate_missing_rs_notification(u.email, year, self.generated).deliver
      end
    end
  end

  def perform(year, _user_id = nil)
    @count = 0
    self.generated = []

    @orchestras = Orchestra.no_report_sheet(year)

    @orchestras.each do |o|
      if o.report_sheet_required?
        rsi = ReportSheetInput.for_orchestra_and_year(o, year)

        if rsi.present?
          rsi.populate_from_last_year
          mglnr = rsi.orchestra.member.mglnr
          self.generated << mglnr
        else
          p "NIL! #{o.member.mglnr}"
        end
      end
    end
  end
end
