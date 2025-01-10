class DummyAddress
  attr_accessor :email, :company, :fullname, :street, :city, :zip, :country_code, :mglnr

  def has_email?
    !email.nil? and email.length > 3
  end

  def event_class
    DummyEvent
  end
end
