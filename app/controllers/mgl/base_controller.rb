module Mgl
  class BaseController < ApplicationController
    before_action :restrict_user_by_role

    # edit valid roles here
    VALID_ROLES = %w[super_admin admin].freeze

    protected

    # redirect if user not logged in or does not have a valid role
    def restrict_user_by_role
      return if current_user || VALID_ROLES.include?(current_user.role)

      redirect_to root_path # change this to your 404 page if needed
    end
  end
end
