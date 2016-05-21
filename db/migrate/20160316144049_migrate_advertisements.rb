class MigrateAdvertisements < ActiveRecord::Migration
  def up
    MagazineAdvert.all.each do |ma|
      c = Contact.find_by_id(ma.advertiser_id)

      ma.advertiser_id = c.contact_entity_id
      ma.save
    end
  end

  def down
  end
end
