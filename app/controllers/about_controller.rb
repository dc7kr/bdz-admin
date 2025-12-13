class AboutController < ApplicationController
  include GitHelper

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
end
