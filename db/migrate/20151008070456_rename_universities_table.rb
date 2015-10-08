class RenameUniversitiesTable < ActiveRecord::Migration
  def up
    rename_table :hochschulen, :universities
  end

  def down
  end
end
