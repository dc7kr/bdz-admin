class EmTariffCorrectJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    digi_tariff = Tariff.where(tariff_type: 21).first
    normal_tariff = Tariff.where(tariff_type: 20).first
    Tariff.where(tariff_type: 25).first

    changed = 0
    unchanged = 0

    digital = []
    normal = []

    PersonMember.includes(:member).find_each do |em|
      mail = em.member.email

      if em.tariff_id == normal_tariff.id
        if (em.member.za == "L") && !mail.nil? && !mail.empty?
          em.tariff = digi_tariff
          em.save
          digital << em
          changed += 1
        else
          unchanged += 1
        end
      elsif em.tariff_id == digi_tariff.id
        if (em.member.za != "L") || mail.nil? || mail.empty?
          em.tariff = normal_tariff
          em.save
          normal << em
          changed += 1
        end
      else
        unchanged += 1
      end
    end

    if changed.positive?
      users = User.for_admin_notify

      users.each do |user|
        AdminNotifier.em_tariff_fix_notification(user, digital, normal, changed, unchanged).deliver
        logger.info "Admin notify sent to %s" % user.email
      end
    else
      logger.info("EM Tariff fix job had no changes.")
    end
  end
end
