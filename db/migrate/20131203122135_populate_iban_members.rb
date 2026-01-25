class PopulateIbanMembers < ActiveRecord::Migration[4.2]
  def up
    Member.unscoped.all.each do |m|
      m.update_attribute :iban, m.iban_calc
      m.save
    end
  end

  def down
  end
end
