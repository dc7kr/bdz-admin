class SepaContactFacade
  def initialize(customer)
    @customer = customer
  end

  def postcode
    @customer.customer.plz
  end

  def city
    @customer.city
  end

  def country
    @customer.customer.t_country('de')
  end

  def phone
    nil
  end

  def email
    nil
  end

  def name
    if @customer.account_owner.nil? or @customer.account_owner.empty?
      Rails.logger.warn("Empty account owner: #{@customer.id}")
      @customer.fullname[0..65]
    else
      @customer.account_owner[0..65]
    end
  end

  def addr
    @customer.street[0..65]
  end

  def contact
    @customer.name[0..65]
  end
end
