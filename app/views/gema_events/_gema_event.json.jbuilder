json.extract! gema_event, :id, :sap_nr, :kdnr, :orchestra_id, :name, :license_nr, :event_date, :description, :location, :tariff, :ticket_total, :admission_price, :music_effort, :visitors, :room_size, :setlist, :gema_amount, :gstv_reduction, :cultural_reduction, :e_reduction, :netto, :created_at, :updated_at
json.url gema_event_url(gema_event, format: :json)
