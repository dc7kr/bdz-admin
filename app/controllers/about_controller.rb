class AboutController < ApplicationController
  include GitHelper

  def index
    commit_count = 10
    commit_count = params[:commit_count].to_i unless params[:commit_count].nil?

    @git_info = git_info(commit_count)
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
