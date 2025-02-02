module Public
  class ApplicationController < ActionController::Base
    include ApplicationHelper

    layout 'public'

    before_action :set_locale
    after_action :allow_iframe_requests

    def allow_iframe_requests
      response.headers.delete('X-Frame-Options')
      # response.headers.except!  "X-Frame-Options"
      Rails.logger.debug('filter x-frame-options public controller')
    end

    private

    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end
