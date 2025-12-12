class ErrorsController < ApplicationController
  layout "error"
  def show
    @exception = request.env["action_dispatch.exception"]
    Rails.logger.error(@exception.backtrace.join("\n"))
    @status_code = @exception.try(:status_code) ||
                   ActionDispatch::ExceptionWrapper.new(
                     request.env, @exception
                   ).status_code
    render view_for_code(@status_code), status: @status_code, content_type: "text/html"
  end

  private

  def view_for_code(code)
    supported_error_codes.fetch(code, "404")
  end

  def supported_error_codes
    {
      403 => "access_denied",
      404 => "not_found",
      406 => "not_acceptable",
      422 => "change_rejected",
      500 => "internal_server_error"
    }
  end
end
