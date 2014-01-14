class SepaContactFacade

  def initialize(member)
    @member=member
  end

  def postcode 
    @member.member.plz
  end

  def city
    @member.member.ort
  end

  def country
    @member.member.t_country("de")
  end

  def phone
    #@member.member.telefon
    nil
  end

  def email
    #@member.member.email
    nil
  end

  def name 
    @member.fullname
  end

  def addr
    @member.member.strasse
  end

  def contact
    @member.fullname
  end
end
