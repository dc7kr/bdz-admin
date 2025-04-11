class MemberEvent < ApplicationRecord
  belongs_to :member

  def has_attachment?
    !filename.nil? and filename.length.positive?
  end

  def self.new_letter(eventId, member, subject)
    retval = MemberEvent.new
    retval.member_id = member
    retval.event_type = 'L'
    retval.event_id = eventId
    retval.event_date = Time.zone.now
    retval.comment = subject

    retval
  end

  def self.new_email(eventId, member, subject)
    retval = MemberEvent.new
    retval.member_id = member
    retval.event_type = 'E'
    retval.event_id = eventId
    retval.event_date = Time.zone.now
    retval.comment = subject

    retval
  end

  def self.new_failed_email(eventId, member, message)
    retval = MemberEvent.new
    retval.member_id = member
    retval.event_type = 'F'
    retval.event_id = eventId
    retval.event_date = Time.zone.now
    retval.comment = message

    retval
  end
end
