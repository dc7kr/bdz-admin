class Infodesk::FestivalApplicationsController < FestivalApplicationsController
  def search
    @festival_application = FestivalApplication.includes(:contact_person).find(params[:search])
  end
end
