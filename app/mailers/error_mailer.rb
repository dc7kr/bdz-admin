class ErrorMailer < ApplicationMailer
  def deliver_snapshot(exception, env, _current_user)
    @body = "#{exception}\n#{exception.backtrace.join("\n")}"

    admin_mail = contact_email("admin")
    mail(to: admin_mail, subject: "Exception in #{env}").deliver_later
  end
end
