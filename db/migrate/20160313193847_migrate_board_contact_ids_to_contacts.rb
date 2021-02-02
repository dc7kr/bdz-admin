class MigrateBoardContactIdsToContacts < ActiveRecord::Migration[4.2]
  def up
    BoardContact.all.each do |bc|
      c = Contact.find_by_id(bc.contact_id_off)

      if not c.nil? then
        c.contact_entity_id = bc.id
        c.contact_entity_type = "BoardContact"
        c.save
      end
    end
  end

  def down
  end
end
