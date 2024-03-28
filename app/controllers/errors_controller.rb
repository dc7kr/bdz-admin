class ErrorsController < ApplicationController

  def not_found
    #render json: {
    #  status: 404,
    #  error: :not_found,
    #  message: 'Where did the 403 errors go'
    #}, status: 404
  end

  def internal_server_error
    #render json: {
    #  status: 500,
    #  error: :internal_server_error,
    #  message: 'Houston we have a problem'
    #}, status: 500
  end

  def internal_server_error
    if not error.nil?
      logger.error("ERROR: "+error.to_s)
      logger.error error.message + "\n " + error.backtrace.join("\n ")
      respond_to do |format|
        format.html {  render(:status=>500) }
      end
    end
  end
end
