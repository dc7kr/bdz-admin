class AuthenticatedController < ApplicationController

  protect_from_forgery

  include Pundit::Authorization
  after_action :verify_pundit_authorization

  before_action :authenticate_user!

  def auditing_security?
    !Rails.env.production?
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    Rails.logger.warn(exception.message)

    msg = exception.message

    query = exception.query
    if not query.present?
      query = "show?"
    end

    t_query = t("common.queries.#{query}")
    
    if exception.record.present? 
      t_class = I18n::t("activerecord.models.#{exception.record.model_name.to_s.underscore}", count: 1)
    else
      t_class = "model"
    end
    
    flash[:error] = t("common.authz_error", query: t_query, class: t_class)

    redirect_to root_url
  end

  def verify_pundit_authorization

    if index_actions.include? action_name.to_sym
      Rails.logger.debug("Action #{action_name} found in index_actions: #{index_actions}")
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  private

  protected

  def index_actions
    [ :index ]
  end
end
