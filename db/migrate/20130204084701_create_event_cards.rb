class CreateEventCards < ActiveRecord::Migration[4.2]
  def change
    create_table :event_cards do |t|

      t.timestamps
    end
  end
end
