# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb

module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404, e)
        end
        rescue_from ActionController::RoutingError do |e|
          respond(:route_not_found, 404, e)
        end
        # critical errors with notify
        rescue_from StandardError do |e|
          logger.error e.message
          logger.error e.backtrace.join("\n")
          ErrorMailer.deliver_snapshot(e, Rails.env, current_user)
          respond(:standard_error, 500, e)
        end
      end
    end

    private

    def respond(_errtype, _status, _error)
      json = Error::Helpers::Render.json(_errtype, _status, _error.to_s)
      render json: json
    end
  end
end
