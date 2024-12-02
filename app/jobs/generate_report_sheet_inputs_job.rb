class GenerateReportSheetInputsJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    AdminNotifier.gen_rsi_notification(job.arguments)
  end

  def perform(year,user_id=nil)

    @count = 0
    @orchestras = Orchestra.regular.includes(:member)
    
    @orchestras.each do |o|
      if not o.nil? and o.report_sheet_required? 
        @rsi = ReportSheetInput.for_orchestra_and_year(o,year)

        if @rsi.nil? then
          @rsi = o.gen_rsi(year)
          
          @count+=1
        end
      else
        if o.nil? then
          logger.warn("Nil orchestra detected!!!")
        else
          logger.info("NO report sheet required: #{o.member.mglnr}") 
        end
      end
    end
  end
end
