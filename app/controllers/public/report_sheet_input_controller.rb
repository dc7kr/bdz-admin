class ReportSheetInputController < ApplicationController


	def index 
# load the gem
require 'spreadsheet'

# In this example the model MyFile has_attached_file :attachment
@workbook = Spreadsheet.open(MyFile.first.attachment.to_file)

# Get the first worksheet in the Excel file
@worksheet = @workbook.worksheet(0)

# It can be a little tricky looping through the rows since the variable
# @worksheet.rows often seem to be empty, but this will work:
0.upto @worksheet.last_row_index do |index|
  # .row(index) will return the row which is a subclass of Array
  row = @worksheet.row(index)

  @contact = Contact.new
  #row[0] is the first cell in the current row, row[1] is the second cell, etc...
  @contact.first_name = row[0]
  @contact.last_name = row[1]

  @contact.save
end

	end
end
