json.extract! gema_event, :id, :kdnr, :name, :zip, :city, :date, :title, :tariff, :amount, :location, :location_city,
              :program_available, :source, :par_mgl, :nf_id, :created_at, :updated_at
json.url gema_event_url(gema_event, format: :json)
