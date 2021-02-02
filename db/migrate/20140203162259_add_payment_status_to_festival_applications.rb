class AddPaymentStatusToFestivalApplications < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :payment_status, :string, :limit=>1 ,:default=>"N"
  end
end
