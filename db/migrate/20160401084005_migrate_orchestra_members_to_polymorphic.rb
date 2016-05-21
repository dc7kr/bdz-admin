class MigrateOrchestraMembersToPolymorphic < ActiveRecord::Migration
  def change
    OrchestraMember.where("orchestra_id_old is not null").each do  |om|
      if not om.orchestra_id_old.nil? then
        m = Member.find_by_id(om.orchestra_id_old) 
        if not m.nil? 
          om.orchestra_id=m.member_entity_id
          om.save
        end
      end
    end
  end
end
