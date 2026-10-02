module Mgl
  class HomeController < BaseController
    skip_after_action :verify_pundit_authorization

    def show
      if current_orchestra
        redirect_to mgl_orchestra_path
      else
        redirect_to mgl_person_member_path
      end
    end
  end
end
