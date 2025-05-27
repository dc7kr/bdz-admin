class Addressee
  attr_accessor :company, :name, :street, :zip, :city, :country_code, :id, :email, :entity, :event_class,
                :event_entity_id

  def has_email?
    !email.nil? and email.length > 3
  end

  def self.dummy_for_mail
    a = Addressee.new

    a.name = "I do have mail"
    a.company = "mail Company"
    a.street = "mail Street 42"
    a.city = "mail City"
    a.zip = "4711"
    a.id = "12345"
    a.country_code = "de"
    a.event_class = nil
    a.event_entity_id = nil
    a.email = "test.bdz@acc.kasi-net.org"

    a
  end

  def self.dummy_for_letter
    a = Addressee.new
    a.id = 23_456

    a.name = "I have no mail"
    a.company = "Nomail Company"
    a.street = "Nomail Street 42"
    a.city = "Nomail City"
    a.zip = "4711"
    a.country_code = "de"
    a.event_class = nil
    a.event_entity_id = nil

    a
  end
end
