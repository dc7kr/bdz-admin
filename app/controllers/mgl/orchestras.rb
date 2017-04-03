require 'rodf'
require 'set'
require 'csv'


class Mgl::OrchestrasController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  include UploadHelper
  include ReportSheetUploadHelper
  include PDFHelper

#  def index
#	@orchestras = Orchestra.includes(:member).where("members.mglnr = ?",current_user.username)
#   
#	Rails.logger("current username: "+current_user.username) 
#	respond_to do |format|
#      format.html {
#			if  ( @orchestras.length == 1 ) then
#				redirect_to @orchestras[0]
#			end
#		}
#    end
#  end

  def show
    @orchestra = Orchestra.includes(:report_sheets).find(params[:id])
    @report_sheets = @orchestra.report_sheets 


    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @orchestra }
    end
  end

  # PUT /orchestras/1.json
  def update
    @orchestra = Orchestra.find(params[:id])

    respond_to do |format|
      if @orchestra.update_attributes(params[:orchestra])
        format.html { redirect_to @orchestra, :notice => t('orchestra.update_success') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @orchestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  def rsi_login
	@orchestra = Orchestra.find(params[:id])

	@rsi = ReportSheetInput.find_by_orchestra_id(@orchestra)	

	
	if ( @rsi != nil ) then

		session[:report_sheet_input_id]=@rsi.id
		session[:report_sheet_input_token]=@rsi.token
		redirect_to step1_report_sheet_input_url(@rsi)
	end
  end

  def gen_rsi
    @orchestra = Orchestra.includes(:member).find(params[:id])

	year = Time.now.year
    anrede = t('common.salutation_d.'+@orchestra.anrede)
	Rails.logger.info(anrede)
	dateprefix = Time.now.strftime '%Y%m%d%H%M%S_'
	@rsi = ReportSheetInput.includes(:report_sheet).where('report_sheet_inputs.orchestra_id = :orchestra_id and report_sheets.year = :year',:orchestra_id=>@orchestra.id, :year=>year+1).first

	if ( @rsi == nil ) then
		@rsi = ReportSheetInput.new_for_orchestra(@orchestra,year+1)
	end

	@rsi.save

    url = "http://www.bdz-online.de/meldebogen/"

	target = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/"+dateprefix+"_"+@orchestra.mglnr.to_s+"_meldebogen_anschreiben.pdf"

	gen_anschreiben(@orchestra,@rsi,url,target,year);
    send_file(target, :filename => target, :type => "application/octet-stream")
  end

  # DELETE /orchestras/1
  # DELETE /orchestras/1.json
  def destroy
    @orchestra = Orchestra.find(params[:id])
    @orchestra.destroy

    respond_to do |format|
      format.html { redirect_to orchestras_url }
      format.json { head :ok }
    end
  end

	
  private 
  def sort_column
    Member.column_names.include?(params[:sort]) ? "members."+params[:sort] :
    Orchestra.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
  end
  private
  def renderNoPayOds(filename,accounts,orchestras)
			RODF::Spreadsheet.file(filename) do
				table "Nopayment" do
	    			orchestras.each do |o|
						row {
							cell o.mglnr.to_s
							cell o.orchName
							cell o.email
							cell accounts[o.member_id],:type=>:float
						}
					end
      end
    end
  end
end
