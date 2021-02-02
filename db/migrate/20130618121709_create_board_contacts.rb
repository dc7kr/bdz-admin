class CreateBoardContacts < ActiveRecord::Migration[4.2]
  def change
    create_table :board_contacts do |t|
      t.integer :contact_id

      t.timestamps
    end
  end
end
