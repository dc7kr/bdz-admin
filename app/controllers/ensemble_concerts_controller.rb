class EnsembleConcertsController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  # GET /ensembles
  # GET /ensembles.json
  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  load_and_authorize_resource
  def index

  end

end
