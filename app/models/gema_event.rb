class GemaEvent
  
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sap_nr, type: Integer
  field :kdnr, type: Integer
  field :name, type: String
  field :license_nr, type: Integer
  field :event_date, type: Date
  field :description, type: String
  field :location, type: String
  field :tariff, type: String
  field :ticket_total, type: Float
  field :admission_price, type: Float
  field :music_effort, type: Float
  field :visitors, type: Integer
  field :room_size, type: Integer
  field :setlist, type: String
  field :gema_amount, type: Float
  field :gstv_reduction, type: Float
  field :cultural_reduction, type: Float
  field :e_reduction, type: Float
  field :netto, type: Float
  # Orchestra is an ActiveRecord model, so it can't be a Mongoid relation
  field :orchestra_id, type: Integer
  index({ orchestra_id: 1 })

  def orchestra
    Orchestra.find_by(id: orchestra_id) if orchestra_id
  end
end
