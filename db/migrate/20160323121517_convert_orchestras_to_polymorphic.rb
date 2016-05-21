class ConvertOrchestrasToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :orchestras, :member_id, :member_id_off
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
  end

  def down
  end
end
