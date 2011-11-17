class CreateEnsembles < ActiveRecord::Migration
  def change
    create_table :ensembles do |t|
      t.string, :name
      t.string, :homepage
      t.string, :beschreibung
      t.string, :email
      t.references, :owner
      t.bool :visible

      t.timestamps
    end
  end
end
