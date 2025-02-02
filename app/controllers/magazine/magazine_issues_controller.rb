module Magazine
  class MagazineIssuesController < AuthorityController
    # GET /magazine_issues
    # GET /magazine_issues.json
    def index
      @magazine_issues = MagazineIssue.order(year: :desc, number: :desc).page(params[:page]).per(3)
      authorize_action_for(@magazine_issues)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @magazine_issues }
      end
    end

    # GET /magazine_issues/1
    # GET /magazine_issues/1.json
    def show
      @magazine_issue = MagazineIssue.find(params[:id])
      authorize_action_for(@magazine_issue)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @magazine_issue }
      end
    end

    def gen_advert_invoices
      @magazine_issue = MagazineIssue.find(params[:id])

      @adverts = @magazine_issue.magazine_adverts.includes(:advertiser)
      pdf = AdvertInvoicesPdf.new(@adverts, Rails.root.join('templates/briefpapier.pdf'))
      send_data pdf.render, filename: "advert_invoices_#{@magazine_issue.number}_#{@magazine_issue.year}.pdf",
                            type: 'application/pdf', disposition: 'inline'
    end

    def gen_subscriber_invoices
      @magazine_issue = MagazineIssue.find(params[:id])

      @subscribers = Subscriber.includes(:contact).order('contacts.last_name,contacts.first_name')
      pdf = MagazineSubscriberInvoicesPdf.new(@subscribers, Rails.root.join('templates/briefpapier.pdf'))
      send_data pdf.render, filename: "subscriber_invoices_#{@magazine_issue.number}_#{@magazine_issue.year}.pdf",
                            type: 'application/pdf', disposition: 'inline'
    end

    # GET /magazine_issues/new
    # GET /magazine_issues/new.json
    def new
      @magazine_issue = MagazineIssue.new
      authorize_action_for(@magazine_issue)

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @magazine_issue }
      end
    end

    # GET /magazine_issues/1/edit
    def edit
      @magazine_issue = MagazineIssue.find(params[:id])
    end

    # POST /magazine_issues
    # POST /magazine_issues.json
    def create
      @magazine_issue = MagazineIssue.new(magazine_params)
      authorize_action_for(@magazine_issue)

      respond_to do |format|
        if @magazine_issue.save
          format.html { redirect_to @magazine_issue, notice: 'Magazine issue was successfully created.' }
          format.json { render json: @magazine_issue, status: :created, location: @magazine_issue }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @magazine_issue.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /magazine_issues/1
    # PUT /magazine_issues/1.json
    def update
      @magazine_issue = MagazineIssue.find(params[:id])

      respond_to do |format|
        if @magazine_issue.update(magazine_params)
          format.html { redirect_to @magazine_issue, notice: 'Magazine issue was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @magazine_issue.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /magazine_issues/1
    # DELETE /magazine_issues/1.json
    def destroy
      authorize_action_for(@magazine_issue)
      @magazine_issue = MagazineIssue.find(params[:id])
      @magazine_issue.destroy

      respond_to do |format|
        format.html { redirect_to magazine_issues_url }
        format.json { head :no_content }
      end
    end

    def counts
      @overall = 0
      @magazine_issue = MagazineIssue.find(params[:id])
      @magazine_samplings = MagazineSampling.sum(:count)

      @overall += @magazine_samplings

      @subscribers = Subscriber.count
      @overall += @subscribers

      @adverts = @magazine_issue.magazine_adverts.count
      @overall += @adverts

      @person_member_count = 0
      @person_members = PersonMember.with_zero_balance
      @person_members.each do |p|
        @person_member_count += p.currentMagazines
      end
      @overall += @person_member_count

      @orchestra_count = 0
      @orchestras = Orchestra.with_zero_balance.includes(:report_sheets)
      @orchestras.each do |o|
        @orchestra_count += o.currentMagazines
      end

      @overall += @orchestra_count
    end

    def magazine_params
      params.require(:magazine_issue).permit(:number, :year)
    end
  end
end
