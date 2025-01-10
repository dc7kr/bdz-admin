class HomeController < AuthenticatedNonResourceController
  skip_authorization_check only: :landing_page
  def landing_page
    if current_user.nil?
      redirect_to new_user_session_path
      return
    end

    if current_user.authentication_token.nil?
      current_user.authentication_token = User.gen_api_token
      current_user.save
    end
    respond_to do |format|
      format.html
    end
  end

  def member_data
    @website_area = 'member_data'
    authorize! :index, Orchestra
    respond_to do |format|
      format.html
    end
  end

  def public_data
    @website_area = 'public_data'
    authorize! :index, Concert
    respond_to do |format|
      format.html
    end
  end

  def reference_data
    @website_area = 'reference_data'
    authorize! :index, RegionalOrganization
    respond_to do |format|
      format.html
    end
  end

  def magazine_data
    @website_area = 'magazine_data'
    authorize! :index, Advertiser
    respond_to do |format|
      format.html
    end
  end

  def festival_data
    @website_area = 'festival_data'
    authorize! :index, FestivalConcert
    respond_to do |format|
      format.html
    end
  end

  def admin_data
    authorize! :user, :destroy
    respond_to do |format|
      format.html
    end
  end

  def tools
    authorize! :member_account_booking, :show
    @views = GenericView.public_views

    respond_to do |format|
      format.html
    end
  end

  def cron
    authorize! :member_account_booking, :show

    respond_to do |format|
      format.html
    end
  end

  def export_view
    authorize! :member_account_booking, :show

    prefix = Time.now.strftime('%Y%m%d') + '_'

    view_suffix = params[:view]

    Rails.logger.info("Exporting view #{view_suffix}")

    filename = prefix + view_suffix + '.ods'

    data = GenericView.connection.select_all("SELECT * from public_#{view_suffix}")

    tmp = Tempfile.new('view')
    writer = OdsViewWriter.new(data, view_suffix)
    writer.write(tmp)
    tmp.close

    logger.info("TMP PATH: #{tmp.path}")

    send_file(tmp.path, filename: filename, type: 'application/octet-stream')
  end

  def current_area
    @current_action
  end
end
