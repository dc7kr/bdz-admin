class ContactEvent < ActiveRecord::Base
  attr_accessible :comment, :contact_id, :event_date, :event_id, :event_type, :filename

  belongs_to :contact_person

	def self.newEmail(eventId,contact,subject)
		retval = ContactEvent.new
		retval.contact_person_id=contact
		retval.event_type="E"
		retval.event_id=eventId
		retval.event_date=Time.now
		retval.comment=subject

		retval
	end

  def self.newFailedEmail(eventId,contact,message)
    retval = ContactEvent.new
    retval.contact_person_id=contact
    retval.event_type="F"
    retval.event_id=eventId
    retval.event_date=Time.now
    retval.comment=message

    retval
  end


	def self.newLetter(eventId,contact,subject)
		retval = ContactEvent.new
    retval.contact_person_id=contact
		retval.event_type="L"
		retval.event_id=eventId
		retval.event_date=Time.now
		retval.comment=subject

		retval
	end

end
