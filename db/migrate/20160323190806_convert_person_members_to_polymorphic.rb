class ConvertPersonMembersToPolymorphic < ActiveRecord::Migration[4.2]
  def change
    rename_column :person_members, :member_id, :member_id_off
    PersonMember.unscoped.all.each do |pm|
      m = Member.find_by_id(pm.member_id_off)
      if not m.nil?  and m.subtype=='PersonMember'
      then
        m.member_entity_id = pm.id
        m.save
      else
      p "Inconsistent"
      end
    end
  end
end
