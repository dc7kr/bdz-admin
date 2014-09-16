class PopulateRegionalOrganizationIban < ActiveRecord::Migration
  def up
    RegionalOrganization.all.each do |ro|
      ro.update_attribute :iban, ro.iban_calc
      ro.save
    end
  end

  def down
  end
end
