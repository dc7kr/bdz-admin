class MemberEvent < ApplicationRecord
  belongs_to :member

  def has_attachment?
    !filename.nil? and filename.length > 0
  end

  def self.newLetter(eventId, member, subject)
    retval = MemberEvent.new
    retval.member_id = member
    retval.event_type = 'L'
    retval.event_id = eventId
    retval.event_date = Time.now
    retval.comment = subject

    retval
  end

  def self.newEmail(eventId, member, subject)
    retval = MemberEvent.new
    retval.member_id = member
    retval.event_type = 'E'
    retval.event_id = eventId
    retval.event_date = Time.now
    retval.comment = subject

    retval
  end

  def self.newFailedEmail(eventId, member, message)
    retval = MemberEvent.new
    retval.member_id = member
    retval.event_type = 'F'
    retval.event_id = eventId
    retval.event_date = Time.now
    retval.comment = message

    retval
  end
end
