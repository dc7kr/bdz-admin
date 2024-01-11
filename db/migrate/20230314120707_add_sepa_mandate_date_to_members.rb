class AddSepaMandateDateToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :sepa_date, :date
  end
end
