class MigrateDistinctionsToPolymorphism < ActiveRecord::Migration
  def change
    Distinction.all.each do |dist|
      if dist.orchestra_id_old.nil? then 
        p "NIL Orchestra: #{dist.id}"
      else
        m = Member.find_by_id(dist.orchestra_id_old)
        if not m.nil? and not m.member_entity_type.nil? and m.member_entity_type = 'Orchestra' then
          dist.orchestra_id = m.member_entity_id 
          #p "#{dist.id}: old: #{dist.orchestra_id_old} new: #{dist.orchestra_id}"
          if not dist.save(validate:false) then
            fail "Could not save"
          end
        end
      end
    end
  end
end
