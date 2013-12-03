class PopulateCountryCodeInMembers < ActiveRecord::Migration
  def up
    Member.all.each do |m|
      m.update_attribute(:country_code,m.country.ccode)
    end
  end

  def down
  end
end
