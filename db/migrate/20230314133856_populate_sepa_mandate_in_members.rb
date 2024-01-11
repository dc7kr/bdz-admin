class PopulateSepaMandateInMembers < ActiveRecord::Migration[5.2]
  def change
    Member.all.each do |m|
      m.sepa_mandate_nr = "BDZBEITRAG#{m.mglnr}"
      m.save(validate:false)
    end
  end
end
