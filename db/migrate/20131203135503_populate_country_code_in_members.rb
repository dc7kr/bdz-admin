class PopulateCountryCodeInMembers < ActiveRecord::Migration[4.2]
  def up
    Member.unscoped.all.each do |m|
      m.update_attribute(:country_code,m.country.ccode)
    end
  end

  def down
  end
end
