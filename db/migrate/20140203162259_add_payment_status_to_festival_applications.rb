class AddPaymentStatusToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :payment_status, :string, :limit=>1 ,:default=>"N"
  end
end
