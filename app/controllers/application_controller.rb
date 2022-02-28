class ApplicationController < ActionController::Base

  before_action :set_locale

  after_action :flash_to_headers


  layout :choose_layout

  @@web_area = {
		"about" => "public_data",
		"addresses" => "public_data",
		"application" => "",
		"classifieds" => "public_data",
		"composers" => "public_data",
		"concerts" => "public_data",
		"contests" => "public_data",
		"countries" => "reference_data",
		"courses" => "public_data",
		"custom_info_mail" => "member_data",
		"distinctions" => "member_data",
		"ensemble_concerts" => "public_data",
		"ensembles" => "public_data",
		"festivals" => "public_data",
		"functions" => "public_data",
		"honor_members" => "public_data",
		"member_account_bookings" => "member_data",
		"member_events" => "member_data",
		"member_report" => "member_data",
		"orchestra_contacts" => "member_data",
		"orchestra_members" => "member_data",
		"orchestras" => "member_data",
		"person_members" => "member_data",
		"regional_organization_bookings" => "reference_data",
		"regional_organizations" => "reference_data",
		"report_sheets" => "member_data",
		"states" => "reference_data",
		"tariffs" => "reference_data",
		"universities" => "public_data",
		"uploads" => "member_data",
		"url_categories" => "public_data",
		"urls" => "public_data",
		"users" => "admin_data",
		"magazine_issues" => "magazine_data",
		"magazine_adverts" => "magazine_data",
		"advertisers" => "magazine_data",
		"calendar_sync" => "admin_data",
    "contact_events" => "festival_data",
    "festival_applications"=> "festival_data",
    "festival_mails" => "festival_data"
	}

  include SessionHelper

	helper_method :current_area

  def goto_login_page
    flash[:error] = "Please login first."
    redirect_to root_url
    #redirect_to home_landing_page_url 
  end

 private
  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s

    # Prevents flash from appearing after page reload.
    # Side-effect: flash won't appear after a redirect.
    # Comment-out if you use redirects.
    flash.discard
  end

  def flash_message
    [:error, :warning, :notice,:success].each do |type|
      return flash[type] unless flash[type].blank?
    end
    return ''
  end

  def flash_type
    [:error, :warning, :notice].each do |type|
      return type unless flash[type].blank?
    end
  end


	protected
      before_action :instantiate_controller_and_action_names
     
      def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
		path = self.controller_path.split('/')
		@namespace = path.second ? path.first : nil
      end

	  def log_error(exception)
		  message = "\n#{exception.class} (#{exception.message}):\n"
		  Rails.logger.warn(message)
		  Rails.logger.warn(exception.to_s+"\n"+exception.backtrace.join("\n"))
	  end



  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end


  # override static error page
  def render_optional_error_file(status_code) 
  	@exception = exception
    #log_error(exception)
    respond_to do |format| 
      format.html { render :template => "/errors/error_500", :layout => 'application', :status => 500 } 
      format.all  { render :nothing => true, :status => 500 } 
    end

  end

  def render_not_found(exception)
    log_error(exception)
    respond_to do |type| 
      type.html { render :template => "/errors/error_404", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    true  # so we can do "render_not_found and return"
  end

  protected
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def choose_layout
	  path = request.fullpath.split('/')
	  namespace = path.second if  path.first
	  if namespace == "public" then
		  "public"
    elsif namespace == "mgl"
      "member_area"
    elsif namespace == "invoice_engine"
      "corika_invoices/application"
	  else 
		  "application"
	  end
  end

  #unless Rails.application.config.consider_all_requests_local
    rescue_from StandardError, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  #end

  protected
    def render_error(status, exception)
      #	if ( current_user == nil or current_user.admin?)
	    begin 
	      logger.error("Encountered error status:"+status.to_s)
        if is_production? then
          ErrorMailer.deliver_snapshot( exception, Rails.env, current_user)
          logger.error("ERROR: "+exception.to_s)
          logger.error exception.message + "\n " + exception.backtrace.join("\n ")
        end
      rescue => e
        logger.error e
        logger.error e.message + "\n " + e.backtrace.join("\n ")
      end

	    @exception = exception

      # needed to prevent double render!
      self.response_body = nil        

      respond_to do |format|
        format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
        format.all { render nothing: true, status: status }
      end
    end

  def is_production?
    ENV["RAILS_ENV"] == "production"
  end

  def current_area
	if @@web_area[@current_controller] then
		@@web_area[@current_controller]
	else
		logger.error("Unmapped controller: "+@current_controller.to_s)
	end
  end

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"

    locale = extract_locale_from_accept_language_header

    begin 
      I18n.locale = locale
    rescue 
      I18n.locale = "en"
    end
  end

  private
  def extract_locale_from_accept_language_header
    accept = request.env['HTTP_ACCEPT_LANGUAGE']
    if (accept == nil ) then
      "de"
    else
      accept.scan(/^[a-z]{2}/).first
    end
  end


  protected
  def sepa?
    not BDZ_SETTINGS["sepa"].nil? and BDZ_SETTINGS["sepa"]==true
  end

end
