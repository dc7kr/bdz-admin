class AboutController < AuthenticatedController
  include GitHelper

  skip_after_action :verify_pundit_authorization

  def index
    @git_info = git_info
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def settings
    @config = Rails.application.config
    @sepa = sepa?

    @deliver_mails = @config.action_mailer.perform_deliveries

    respond_to do |format|
      format.html
    end
  end

  protected
  def index_actions
    []
  end
end
