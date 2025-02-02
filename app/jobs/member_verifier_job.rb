class MemberVerifierJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    orch_invalid = []
    em_invalid = []

    Orchestra.includes(:member).find_each do |o|
      orch_invalid << { mglnr: o.member.mglnr, bic: o.member.bic } if o.member.bic.present? && !o.member.is_bic_valid?
    end

    PersonMember.includes(:member).find_each do |em|
      em_invalid << { mglnr: em.member.mglnr, bic: em.member.bic } if em.member.bic.present? && !em.member.is_bic_valid?
    end

    return unless em_invalid.length.positive? || orch_invalid.length.positive?

    # users = User.for_admin_notify
    users = User.for_developer_notify

    users.each do |user|
      AdminNotifier.invalid_member_notification(user, orch_invalid, em_invalid).deliver
      logger.info 'Admin notify sent to %s' % user.email
    end
  end
end
