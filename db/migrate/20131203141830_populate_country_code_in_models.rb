class PopulateCountryCodeInModels< ActiveRecord::Migration[4.2]
  def up

    models = [ State, Url, Concert, Festival, ContactPerson, Contact, University ]
    
    models.each do |mc|
      mc.all.each do |m|
        m.update_attribute(:country_code,m.country.ccode) unless m.country.nil?
      end
    end
  end

  def down
  end
end
