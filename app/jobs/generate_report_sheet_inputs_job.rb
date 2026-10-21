class GenerateReportSheetInputsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  after_perform do |job|
    AdminNotifier.gen_rsi_notification(job.arguments)
  end

  def perform(year, _user_id = nil)
    @count = 0
    @passwords = 0
    @orchestras = Orchestra.regular.includes(:member)

    @orchestras.each do |o|
      if !o.nil? && o.report_sheet_required?
        rsi = ReportSheetInput.for_orchestra_and_year(o, year)

        if rsi.nil?
          o.gen_rsi(year)
          rsi = ReportSheetInput.for_orchestra_and_year(o, year)

          @count += 1
        end

        set_member_password(o, rsi)
      elsif o.nil?
        logger.warn("Nil orchestra detected!!!")
      else
        logger.info("NO report sheet required: #{o.member.mglnr}")
      end
    end

    logger.info("Generated #{@count} report sheet inputs, set #{@passwords} member passwords")
  end

  private

  # The letter tells the orchestra to sign in with the member number and the
  # token of the report sheet input as password. Orchestras that don't have a
  # password for the member area yet get the token as password, so the same
  # credentials work there. Existing passwords are left alone.
  def set_member_password(orchestra, rsi)
    return if rsi.nil?

    if orchestra.member.set_initial_password(rsi.token)
      @passwords += 1
      logger.info("Set member area password of #{orchestra.member.mglnr}")
    end
  end
end
