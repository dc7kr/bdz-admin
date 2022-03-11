class ErrorsController < ApplicationController
  def not_found
    render(:status=>404)
  end

  def internal_server_error

          ErrorMailer.deliver_snapshot( exception, Rails.env, current_user)
          logger.error("ERROR: "+exception.to_s)
          logger.error exception.message + "\n " + exception.backtrace.join("\n ")
    respond_to do |format|
      format.html {  render(:status=>500) }
    end
  end
end
