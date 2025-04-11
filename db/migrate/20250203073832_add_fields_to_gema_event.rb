class AddFieldsToGemaEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :gema_events, :sap_nr, :integer
    add_reference :gema_events, :orchestra, null: false, foreign_key: true
    add_column :gema_events, :license_nr, :integer
    add_column :gema_events, :event_date, :date
    add_column :gema_events, :ticket_total, :float
    add_column :gema_events, :admission_price, :float
    add_column :gema_events, :music_effort, :float
    add_column :gema_events, :visitors, :integer
    add_column :gema_events, :room_size, :integer
    add_column :gema_events, :setlist, :string
    add_column :gema_events, :gema_amount, :float
    add_column :gema_events, :gstv_reduction, :float
    add_column :gema_events, :cultural_reduction, :float
    add_column :gema_events, :e_reduction, :float
    add_column :gema_events, :netto, :float
  end
end
