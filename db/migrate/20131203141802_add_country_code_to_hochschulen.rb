class AddCountryCodeToHochschulen< ActiveRecord::Migration[4.2]
  def change
      add_column :universities, :country_code, :string, :limit=>2
  end
end
