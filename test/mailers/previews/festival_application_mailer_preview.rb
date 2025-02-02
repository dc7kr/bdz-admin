# Preview all emails at http://localhost:3000/rails/mailers/festival_application_mailer
class FestivalApplicationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/festival_application_mailer/confirm
  def confirm
    FestivalApplicationMailer.confirm
  end
end
