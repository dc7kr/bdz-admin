class Cron::DownloadsController < ApplicationController

  def index
	fNam = params[:filename]

    fullPath = BDZ_SETTINGS['invoice_archive_dir']+"/"+params[:year]+"/"+fNam
    send_file(fullPath, :filename => fNam, :type => "application/octet-stream")
  end

end
