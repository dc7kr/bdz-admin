require 'fileutils'

module Cron
  class InvoicesController < AuthenticatedNonResourceController
    # load_and_authorize_resource

    def gen_all
      authorize! :member, :edit
      year = if params[:year]
               params[:year].to_i
             else
               Time.zone.now.year
             end

      orchestraInvoices(year)
      personMemberInvoices(year)
      render text: 'Generation OK.'
    end

    def ping
      authorize! :member, :edit
      render text: 'Pong'
    end

    def gen_orchestras
      authorize! :member, :edit

      year = if params[:year]
               params[:year].to_i
             else
               Time.zone.now.year
             end

      OrchestraInvoicesJob.perform_later(year, @current_user.id)

      respond_to do |format|
        format.html { redirect_to home_cron_path, notice: t('cron.invoice_orchestras_success') }
      end
    end

    def gen_persons
      authorize! :member, :edit

      year = if params[:year]
               params[:year].to_i
             else
               Time.zone.now.year
             end

      PersonMemberInvoicesJob.perform_later(year, @current_user.id)

      respond_to do |format|
        format.html { redirect_to home_cron_path, notice: t('cron.invoice_person_member_success') }
      end
    end

    def test_gen
      authorize! :member, :edit
      testGen(params[:date])
      render text: 'Generation OK.'
    end

    def testGen(datepref)
      @dw = DtausWriter.new
      @dw.overrideDate(datepref)
      @dw.genDtaus
      @tw.moveGeneratedFiles(@sw.datePrefix)
    end
  end
end
