require 'prawn'
require 'pdf/toolkit'

class ReportSheetInputLetterJob < ApplicationJob
  queue_as :default

  def perform(orchestra_id, rsi_id)
    orchestra = Orchestra.find(orchestra_id)
    rsi = ReportSheetInput.find(rsi_id)

    pdf = ReportSheetInputLetterPdf.new(orchestra, rsi)
    pdf.generate
  end
end
