class MigrateAdvertisements < ActiveRecord::Migration[4.2]
  def up
    MagazineAdvert.all.each do |ma|
      c = Contact.find_by_id(ma.advertiser_id)
      if not c.nil?
        ma.advertiser_id = c.contact_entity_id
        ma.save
      end
    end
  end

  def down
  end
end
