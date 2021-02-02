class PopulateOrchestraContactsCountryCode < ActiveRecord::Migration[4.2]
  def up
    execute "update orchestra_contacts set country_code='de' where country is null"
  end

  def down
  end
end
