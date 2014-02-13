class SepaContactFacade

  def initialize(member)
    @member=member
  end

  def postcode 
    @member.member.plz
  end

  def city
    @member.member.ort[0..65]
  end

  def country
    @member.member.t_country("de")
  end

  def phone
    #@member.member.telefon[0..65]
    nil
  end

  def email
    #@member.member.email[0..65]
    nil
  end

  def name 
    @member.account_owner[0..65]
  end

  def addr
    @member.member.strasse[0..65]
  end

  def contact
    @member.fullname[0..65]
  end
end
