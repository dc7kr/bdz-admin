class AddFestivalApplicationToContactPerson < ActiveRecord::Migration
  def change
    add_reference :contact_people, :festival_application, index: true
  end
end
