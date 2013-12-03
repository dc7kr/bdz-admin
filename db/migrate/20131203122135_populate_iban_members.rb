class PopulateIbanMembers < ActiveRecord::Migration
  def up
    Member.all.each do |m|
      m.update_attribute :iban, m.iban_calc
      m.save
    end
  end

  def down
  end
end
