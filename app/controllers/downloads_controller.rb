class DownloadsController < ApplicationController
  def show
      authorize! :index, Orchestra

      fNam = params[:filename]

      format = params[:format]

      fullPath = "#{DOCS_CONFIG.archive_dir}/#{params[:year]}/#{fNam}.#{format}"

      Rails.logger.info(fullPath)

      if File.exist?(fullPath)
        send_file(fullPath, filename: fNam, type: "application/octet-stream")
      else
        render "errors/404", content_type: "text/html", layout: false, status: :not_found
      end
  end
end
