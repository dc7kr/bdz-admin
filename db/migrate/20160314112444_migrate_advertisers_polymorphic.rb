class MigrateAdvertisersPolymorphic < ActiveRecord::Migration[4.2]
  def up

    Advertiser.all.each do |adv|
      c = Contact.find_by_id(adv.contact_id_off)

      if not c.nil? then
        c.contact_entity_type="Advertiser"
        c.contact_entity_id = adv.id
        c.save
      end
      
    end
  end

  def down
  end
end
