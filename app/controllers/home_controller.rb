class HomeController < AuthenticatedController
  skip_after_action :verify_pundit_authorization, only: :landing_page
  skip_before_action :authenticate_user!, only: :landing_page

  def landing_page
    if current_user.nil?
      redirect_to new_user_session_path, format: :html
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
    @website_area = "member_data"
    authorize Orchestra, :show?
    respond_to do |format|
      format.html
    end
  end

  def public_data
    @website_area = "public_data"
    authorize Concert, :show?
    respond_to do |format|
      format.html
    end
  end

  def reference_data
    @website_area = "reference_data"
    authorize State, :show?
    respond_to do |format|
      format.html
    end
  end

  def magazine_data
    @website_area = "magazine_data"
    authorize Advertiser, :show?
    respond_to do |format|
      format.html
    end
  end

  def festival_data
    @website_area = "festival_data"
    authorize FestivalConcert, :show?
    respond_to do |format|
      format.html
    end
  end

  def admin_data
    authorize User, :destroy
    respond_to do |format|
      format.html
    end
  end

  def tools
    authorize MemberAccountBooking, :show?
    @views = GenericView.public_views

    respond_to do |format|
      format.html
    end
  end

  def cron
    authorize MemberAccountBooking, :show?

    respond_to do |format|
      format.html
    end
  end

  def export_view
    authorize MemberAccountBooking, :show?

    prefix = "#{Time.zone.now.strftime('%Y%m%d')}_"

    view_suffix = params[:view]

    Rails.logger.info("Exporting view #{view_suffix}")

    filename = "#{prefix}#{view_suffix}.ods"

    data = GenericView.connection.select_all("SELECT * from public_?", view_suffix)

    tmp = Tempfile.new("view")
    writer = OdsViewWriter.new(data, view_suffix)
    writer.write(tmp)
    tmp.close

    logger.info("TMP PATH: #{tmp.path}")

    send_file(tmp.path, filename: filename, type: "application/octet-stream")
  end

  def current_area
    @current_action
  end
end
