class Cron::DownloadsController < AuthenticatedNonResourceController

  def index
  	authorize! :index, Orchestra

	fNam = params[:filename]

    fullPath = BDZ_SETTINGS['docs_archive_dir']+"/"+params[:year]+"/"+fNam
    
    if File.exists?(fullPath) 
      send_file(fullPath, :filename => fNam, :type => "application/octet-stream")
    else
      respond_to do |format|
        format.html
      end
    end
  end

end
