class ErrorMailer < ApplicationMailer
  def deliver_snapshot(exception, env, _current_user)
    @body = exception.to_s + "\n" + exception.backtrace.join("\n")
    sender = 'bdzdb@zupfmusiker.de'

    admin_mail = BDZ_SETTINGS['contacts']['admin']['mail']
    mail(to: admin_mail, subject: 'Exception in ' + env, from: sender).deliver_later
  end
end
