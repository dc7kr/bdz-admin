class ConvertOrchestrasToPolymorphic < ActiveRecord::Migration[4.2]
  def up
    Orchestra.all.each do |o|
      m = Member.find_by_id(o.member_id)
      if not m.nil?  and m.subtype=='Orchestra'
      then
        m.member_entity_id = o.id
        m.save
      else
      p "Inconsistent"
      end
    end
    rename_column :orchestras, :member_id, :member_id_off
  end

  def down
  end
end
