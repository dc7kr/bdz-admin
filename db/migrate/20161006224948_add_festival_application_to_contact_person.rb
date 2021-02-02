class AddFestivalApplicationToContactPerson < ActiveRecord::Migration[4.2]
  def change
    add_reference :contact_people, :festival_application, index: true
  end
end
