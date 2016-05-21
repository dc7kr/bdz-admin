class MigrateContactsToOrchestra < ActiveRecord::Migration
  def change
    OrchestraContact.all.each do |oc|
      if oc.orchestra_id_old.nil? then 
        p "NIL Orchestra: #{oc.id}"
      else
        m = Member.find_by_id(oc.orchestra_id_old)
        if not m.nil? and not m.member_entity_type.nil? and m.member_entity_type = 'Orchestra' then
          oc.orchestra_id = m.member_entity_id 
          #p "#{oc.id}: old: #{oc.orchestra_id_old} new: #{oc.orchestra_id}"
          if not oc.save(validate:false) then
            fail "Could not save"
          end
        end
      end
    end
  end
end
