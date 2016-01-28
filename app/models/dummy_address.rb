class DummyAddress 

  attr_accessor :email,:company,:fullname, :street,:city,:zip,:country_code

  def has_email?
    not email.nil? and email.length > 3
  end

end
