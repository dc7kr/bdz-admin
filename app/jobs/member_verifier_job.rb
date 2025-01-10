class MemberVerifierJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    orch_invalid = []
    em_invalid = []

    Orchestra.includes(:member).each do |o|
      orch_invalid << { mglnr: o.member.mglnr, bic: o.member.bic } if o.member.bic.present? and !o.member.is_bic_valid?
    end

    PersonMember.includes(:member).each do |em|
      em_invalid << { mglnr: em.member.mglnr, bic: em.member.bic } if em.member.bic.present? and !em.member.is_bic_valid?
    end

    return unless em_invalid.length > 0 or orch_invalid.length > 0

    # users = User.for_admin_notify
    users = User.for_developer_notify

    users.each do |user|
      AdminNotifier.invalid_member_notification(user, orch_invalid, em_invalid).deliver
      logger.info 'Admin notify sent to %s' % user.email
    end
  end
end
