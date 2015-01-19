class AddUuidToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :uuid, :string

    FestivalApplication.all do |fa|
      fa.uuid = UUID.new
      fa.save
    end
  end
end
