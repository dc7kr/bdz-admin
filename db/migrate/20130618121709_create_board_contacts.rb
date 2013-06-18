class CreateBoardContacts < ActiveRecord::Migration
  def change
    create_table :board_contacts do |t|
      t.integer :contact_id

      t.timestamps
    end
  end
end
