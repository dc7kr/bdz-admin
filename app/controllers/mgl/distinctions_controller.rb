module Mgl
  # read only
  class DistinctionsController < BaseController
    def index
      authorize Distinction
      @distinctions = policy_scope(Distinction).order(dist_date: :desc)
    end

    def show
      @distinction = policy_scope(Distinction).find(params[:id])
      authorize @distinction
    end
  end
end
