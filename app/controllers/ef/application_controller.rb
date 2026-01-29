module Ef
  class ApplicationController < ActionController::Base
    helper ::ApplicationHelper
    helper ::ButtonHelper
    helper ::FontAwesomeHelper
    helper ::NavHelper


    layout :ef_layout

    def ef_layout
      return "turbo_rails/frame" if turbo_frame_request?

      "ef"
    end

    before_action :set_locale
    after_action :allow_iframe_requests

    def allow_iframe_requests
      response.headers.delete("X-Frame-Options")
      # response.headers.except!  "X-Frame-Options"
      #Rails.logger.debug("filter x-frame-options public controller")
    end

    private

    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end
