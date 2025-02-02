class FestivalApplicationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.festival_application_mailer.confirm.subject
  #
  def confirm
    @greeting = 'Hi'

    @appl = params[:appl]

    mail to: @appl.contact_person.email
  end
end
