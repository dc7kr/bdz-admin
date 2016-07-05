class Addressee
  attr_accessor :company,:name,:street,:zip,:city,:country_code,:id,:email, :entity, :event_class, :event_entity_id


  def has_email?
    not email.nil? and email.length > 3
  end
end
