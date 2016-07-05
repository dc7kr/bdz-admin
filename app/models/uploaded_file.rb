class UploadedFile < ActiveRecord::Base
  #attr_accessible :correct_ds, :faulty_ds, :filename

	belongs_to :report_sheet_input
end
