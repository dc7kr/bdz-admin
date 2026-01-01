class PersonMemberTariffCorrectionJob < ApplicationJob
  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject,
                  retry: false

  def perform(year = nil)
    year = Time.zone.now.year if year.nil?

    em_digital = Tariff.find_by_tag("em_digital")
    em_regular = Tariff.find_by_tag("em")
    em_youngster = Tariff.find_by_tag("em_youngster")

    person_members = PersonMember.where("? - year(geburtstag) >=28 and tariff_id = ?",year, em_youngster.id)

    txt = []

    changes = []

    person_members.each do |pm|
      if pm.member.email.empty? or not pm.member.direct_debit?
        pm.tariff = em_regular
      else
        pm.tariff = em_digital
      end

      changes << "#{pm.member.mglnr} #{pm.member.fullname}: #{pm.tariff.description}\n"
    end

    User.for_admin_notify.each do |u|
      AdminNotifier.em_tariff_fix_notification(u, changes).deliver
    end
  end
end
