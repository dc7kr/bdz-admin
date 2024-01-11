class AddInactiveFlagToMagazineSamplings < ActiveRecord::Migration[5.2]
  def change
    add_column :magazine_samplings, :inactive, :boolean, :default => false
  end
end
