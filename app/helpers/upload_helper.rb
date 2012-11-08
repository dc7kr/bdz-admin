module UploadHelper

  def readDataFile(email_params)
	if ( email_params[:datafile] ) then 
		dataFile = email_params[:datafile]
		return dataFile.read
	else
		return nil
	end
  end
end
