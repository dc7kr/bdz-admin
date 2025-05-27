module Adm
  class LetterFileRegenerationController < AuthenticatedNonResourceController
    def index
      params[:event]

      LetterFileRegenerationJob.with(event: params[:event], triggered_by: current_user).perform_later

      respond_to do |format|
        format.html { redirect_to request.referer, notice: t("adm.letter_regeneration_job_started") }
      end
    end
  end
end
