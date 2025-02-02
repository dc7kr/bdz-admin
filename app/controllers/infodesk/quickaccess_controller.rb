module Infodesk
  class QuickaccessController < AuthenticatedNonResourceController
    def index
      authorize! :member, :edit
    end
  end
end
