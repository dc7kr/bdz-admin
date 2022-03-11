class MemberVerifierJob < ApplicationJob
  queue_as :default

  def perform(*args)

    orch_invalid = Array.new
    em_invalid = Array.new

    Orchestra.includes(:member).each do |o|
      if not o.member.bic.nil? and not o.member.bic.empty? and not o.member.is_bic_valid?
        orch_invalid << { mglnr: o.member.mglnr, bic: o.member.bic }
      end
    end

    PersonMember.includes(:member).each  do |em| 
      if not em.member.bic.nil? and not em.member.bic.empty? and not em.member.is_bic_valid?
        em_invalid << { mglnr: em.member.mglnr, bic: em.member.bic }
      end
    end

    if em_invalid.length > 0 or orch_invalid.length > 0 
      #users = User.for_admin_notify
      users = User.for_developer_notify

      users.each do |user|
        AdminNotifier.invalid_member_notification(user,orch_invalid, em_invalid).deliver
        logger.info 'Admin notify sent to %s' % user.email
      end
    end
  end
end

