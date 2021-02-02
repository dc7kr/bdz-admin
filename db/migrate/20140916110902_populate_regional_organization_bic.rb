class PopulateRegionalOrganizationBic < ActiveRecord::Migration[4.2]
  def up
    bic_finder = BicFinder.new

    RegionalOrganization.all.each do |ro|
      bic = bic_finder.bic_for_blz(ro.blz.to_s)
      ro.update_attribute :bic , bic
      ro.save
    end
  end

  def down
  end
end
