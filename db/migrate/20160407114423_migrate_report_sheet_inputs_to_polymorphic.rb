class MigrateReportSheetInputsToPolymorphic < ActiveRecord::Migration[4.2]
  def change
    ReportSheetInput.all.where("orchestra_id_old is not null").each do  |rsi|
      if not rsi.orchestra_id_old.nil? then
        m = Member.find_by_id(rsi.orchestra_id_old) 
        if not m.nil? 
          rsi.orchestra_id=m.member_entity_id
          rsi.save
        end
      end
    end
  end
end
