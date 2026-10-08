class PersonMemberTariffCorrectionJob < ApplicationJob
  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject,
                  retry: false

  def perform(year = nil)
    year = Time.zone.now.year if year.nil?

    em_digital = Tariff.find_by_tag!("em_digital")
    em_regular = Tariff.find_by_tag!("em")
    em_youngster = Tariff.find_by_tag!("em_youngster")

    person_members = PersonMember.includes(:member).where("? - year(geburtstag) >=28 and tariff_id = ?",year, em_youngster.id)

    changes = []

    person_members.each do |pm|
      if pm.member.email.blank? or not pm.member.direct_debit?
        pm.tariff = em_regular
      else
        pm.tariff = em_digital
      end

      if pm.save
        changes << "#{pm.member.mglnr} #{pm.member.fullname}: #{pm.tariff.description}"
      else
        logger.error "Tariff correction failed for #{pm.member.mglnr}: #{pm.errors.full_messages.join(', ')}"
        changes << "#{pm.member.mglnr} #{pm.member.fullname}: FEHLER - #{pm.errors.full_messages.join(', ')}"
      end
    end

    User.for_admin_notify.each do |u|
      AdminNotifier.em_tariff_fix_notification(u, changes).deliver_now
      logger.info "Admin notify sent to #{u.email}"
    end
  end
end
