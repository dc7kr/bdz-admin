class PopulateRegionalOrganizationIban < ActiveRecord::Migration[4.2]
  def up
    RegionalOrganization.all.each do |ro|
      ro.update_attribute :iban, ro.iban_calc
      ro.save
    end
  end

  def down
  end
end
