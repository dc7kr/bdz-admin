class PopulateOrchestraContactsCountryCode < ActiveRecord::Migration
  def up
    execute "update orchestra_contacts set country_code='de' where country is null"
  end

  def down
  end
end
