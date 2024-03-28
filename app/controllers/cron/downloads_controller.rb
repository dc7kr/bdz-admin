class Cron::DownloadsController < AuthenticatedNonResourceController

  def index
  	authorize! :index, Orchestra

	fNam = params[:filename]

    fullPath = DOCS_CONFIG.archive_dir+"/"+params[:year]+"/"+fNam
    
    if File.exist?(fullPath) 
      send_file(fullPath, :filename => fNam, :type => "application/octet-stream")
    else
      respond_to do |format|
        format.html
      end
    end
  end
end
