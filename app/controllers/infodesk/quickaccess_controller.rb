class Infodesk::QuickaccessController < AuthenticatedNonResourceController
  def index
    authorize! :member, :edit
  end
end
