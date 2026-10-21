class PersonMemberTariffCorrectionJob < ApplicationJob
  sidekiq_options lock: :while_executing,
                  lock_timeout: 2,
                  on_conflict: :reject,
                  retry: false

  YOUNGSTER_MAX_AGE = 28

  # Rules:
  # * members outside Germany always get the international tariff
  # * youngsters turning 28 in the given year move to digital (email + direct debit) or regular
  # * digital members without email or direct debit are reset to the regular tariff
  def perform(year = nil)
    year = Time.zone.now.year if year.nil?

    em_digital = Tariff.find_by_tag!("em_digital")
    em_regular = Tariff.find_by_tag!("em")
    em_youngster = Tariff.find_by_tag!("em_youngster")
    em_foreign = Tariff.find_by_tag!("em_foreign")

    tariff_ids = [ em_digital, em_regular, em_youngster, em_foreign ].map(&:id)

    changes = []

    PersonMember.includes(:member, :tariff).where(tariff_id: tariff_ids).find_each do |pm|
      member = pm.member
      next if member.nil?

      target = target_tariff(pm, year, em_digital:, em_regular:, em_youngster:, em_foreign:)
      next if target == pm.tariff

      old = pm.tariff.description
      pm.tariff = target

      if pm.save
        changes << "#{member.mglnr} #{member.fullname}: #{old} -> #{pm.tariff.description}"
      else
        logger.error "Tariff correction failed for #{member.mglnr}: #{pm.errors.full_messages.join(', ')}"
        changes << "#{member.mglnr} #{member.fullname}: FEHLER - #{pm.errors.full_messages.join(', ')}"
      end
    end

    if changes.empty?
      logger.info "Person member tariff correction had no changes."
      return
    end

    User.for_admin_notify.each do |u|
      AdminNotifier.em_tariff_fix_notification(u, changes).deliver_now
      logger.info "Admin notify sent to #{u.email}"
    end
  end

  private

  def target_tariff(pm, year, em_digital:, em_regular:, em_youngster:, em_foreign:)
    member = pm.member

    return em_foreign if abroad?(member)
    return pm.tariff if pm.tariff == em_foreign # German members on the international tariff are left alone

    aged_out = pm.tariff == em_youngster && pm.geburtstag.present? && year - pm.geburtstag.year >= YOUNGSTER_MAX_AGE

    if aged_out || pm.tariff == em_digital
      digital_eligible?(member) ? em_digital : em_regular
    else
      pm.tariff
    end
  end

  def abroad?(member)
    member.country_code.present? && member.country_code.upcase != "DE"
  end

  def digital_eligible?(member)
    member.email.present? && member.direct_debit?
  end
end
