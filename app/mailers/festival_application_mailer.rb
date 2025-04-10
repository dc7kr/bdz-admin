class FestivalApplicationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.festival_application_mailer.confirm_create.subject
  #
  def confirm_create(festival_application_id)

    @appl = FestivalApplication.find_by token: festival_application_id 

    mail to: @appl.contact_person.email
  end

  def confirm_update(festival_application_id)

    @appl = FestivalApplication.find_by token: festival_application_id

    mail to: @appl.contact_person.email
end
