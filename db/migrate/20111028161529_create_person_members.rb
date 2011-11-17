class CreatePersonMembers < ActiveRecord::Migration
  def change
    create_table :person_members do |t|

      t.timestamps
    end
  end
end
