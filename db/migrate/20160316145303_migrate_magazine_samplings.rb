class MigrateMagazineSamplings < ActiveRecord::Migration
  def up
    MagazineSampling.all.each do |ms|
      c = Contact.find_by_id(ms.contact_id)

      if c.nil? then
        p "NIL: #{ms.id}"
      else
        c.contact_entity_type="MagazineSampling"
        c.contact_entity_id = ms.id
        c.save
      end
    end
  end

  def down
  end
end
