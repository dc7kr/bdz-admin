class Public::ApplicationController  < ActionController::Base

  before_filter :set_locale

  layout "public"

  include ApplicationHelper

 private
    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end
end
