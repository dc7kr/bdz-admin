class RenameUniversitiesTable < ActiveRecord::Migration[4.2]
  def up
    rename_table :hochschulen, :universities
  end

  def down
  end
end
