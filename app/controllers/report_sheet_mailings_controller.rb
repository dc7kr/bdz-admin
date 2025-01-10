class ReportSheetMailingsController < AuthenticatedNonResourceController
  include PdfHelper
  include BulkMailHelper

  def gen_mailings
    authorize! :index, Orchestra

    now = Time.now

    rs_year = if params[:year].nil?
                now.year + 1
              else
                params[:year].to_i
              end

    ReportSheetMailingsJob.perform_later(rs_year, @current_user)

    respond_to do |format|
      format.html do
        redirect_to home_cron_path, notice: t('report_sheet_mailing.generation_triggered')
      end
    end
  end

  def test
    Time.now.strftime '%Y%m%d'
    cur_year = Time.now.strftime '%Y'
    rs_year = if params[:year].nil?
                Time.now.year + 1
              else
                params[:year].to_i
              end

    event_id = 'MB_' + rs_year.to_s
    subject = 'Meldebogen Anschreiben ' + rs_year.to_s

    tool = MailingTool.new(cur_year.to_s, 'gs', event_id, subject)

    orchestra = Orchestra.joins(:member).where('members.mglnr = ?', 1045).first

    orchestra.member.email = 'kr@corika.com'

    @rsi = ReportSheetInput.for_orchestra_and_year(orchestra, rs_year)

    letterArray = []

    mailer_params = { rsi: @rsi }
    mailing_pdf = gen_anschreiben(orchestra, @rsi)

    tool.deliver_mailing(ReportSheetInputMailer, orchestra.to_addressee, mailing_pdf, nil, letterArray,
                         mailer_params)

    send_file(mailing_pdf.full_path, filename: 'meldeboegen_anschreiben.pdf', type: 'application/octet-stream')
  end
end
