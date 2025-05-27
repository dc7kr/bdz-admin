class GenerateReportSheetInputsJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    AdminNotifier.gen_rsi_notification(job.arguments)
  end

  def perform(year, _user_id = nil)
    @count = 0
    @orchestras = Orchestra.regular.includes(:member)

    @orchestras.each do |o|
      if !o.nil? && o.report_sheet_required?
        rsi = ReportSheetInput.for_orchestra_and_year(o, year)

        if rsi.nil?
          o.gen_rsi(year)

          @count += 1
        end
      elsif o.nil?
        logger.warn("Nil orchestra detected!!!")
      else
        logger.info("NO report sheet required: #{o.member.mglnr}")
      end
    end
  end
end
