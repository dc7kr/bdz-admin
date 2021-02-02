class MigrateReportSheetToOrchestra < ActiveRecord::Migration[4.2]
  def change
    ReportSheet.all.each do |rs|
      if rs.orchestra_id_old.nil? then 
        p "NIL Orchestra: #{rs.id}"
      else
        m = Member.find_by_id(rs.orchestra_id_old)
        if not m.nil? and not m.member_entity_type.nil? and m.member_entity_type = 'Orchestra' then
          rs.orchestra_id = m.member_entity_id 
          #p "#{rs.id}: old: #{rs.orchestra_id_old} new: #{rs.orchestra_id}"
          if not rs.save(validate:false) then
            fail "Could not save"
          end
        end
      end
    end
  end
end
