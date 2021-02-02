class CreateMagazineIssues < ActiveRecord::Migration[4.2]
  def change
    create_table :magazine_issues do |t|
      t.integer :year
      t.integer :number

      t.timestamps
    end
  end
end
