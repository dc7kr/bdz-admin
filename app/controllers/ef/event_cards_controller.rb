module Ef
  class EventCardsController < Ef::ApplicationController
    include ::ApplicationHelper
    helper ::FontAwesomeHelper

    helper_method :entity_row

    before_action :set_event_card

    def invalid_state

    end

    def order_form
      @event_card = event_card_from_session

      if @event_card.present?
        Rails.logger.debug("EC session ref: #{@event_card.checkout_reference}")
        invoice = @event_card.to_invoice

        if invoice.pdf_filename.present?
          @event_card = nil
          set_checkout_reference(nil)
        end
      end

      if @event_card.nil?
        @event_card = EventCard.new
        @event_card.country_code = "DE"
      end

      @url = order_ef_event_cards_path(format: :html)

      @prices = BDZ_SETTINGS["festival_prices"]
    end

    def update
      @event_card = event_card_from_session

      if @event_card.order_state == 99
        redirect_to invalid_state_ef_event_cards_path
        return
      end

      @event_card.update(event_card_params)
      if @event_card.save
        redirect_to choose_payment_ef_event_card_path(@event_card)
      else
        render partial: "order_form", status: :unprocessable_entity
      end
    end

    def order
      @event_card = event_card_from_session

      if @event_card.nil?
        session[:checkout_reference] =nil
        @event_card = EventCard.new(event_card_params)
      else
        @event_card.update(event_card_params)
      end

      if @event_card.checkout_reference.nil?
        uuid = SecureRandom.uuid
        @event_card.checkout_reference = uuid
        set_checkout_reference(uuid)
      end

      @prices = BDZ_SETTINGS["festival_prices"]

      @event_card.festival_year = BDZ_SETTINGS["config"]["festival_year"]
      @event_card.orderdate = Time.zone.now


      if @event_card.save
        session[:checkout_reference] = @event_card.checkout_reference
        redirect_to choose_payment_ef_event_card_path(@event_card)
      else
        respond_to do |format|
          Rails.logger.error(@event_card.errors)
          format.html { render action: "order_form", status: :unprocessable_entity }
          format.json { render json: @event_card.errors, status: :unprocessable_entity }
        end
      end
    end

    def order_success
      @event_card = EventCard.new(event_card_params)
      @prices = BDZ_SETTINGS["festival_prices"]

      @event_card.orderdate = Time.zone.now

      @event_card.checkout_reference = SecureRandom.uuid

      respond_to do |format|
        if @event_card.save
          EventCardsMailer.notify(@event_card, "kartenbestellung@bdz-online.de").deliver
          format.html
          format.json { render json: @event_card, status: :created, location: @event_card }
        else
          Rails.logger.error(@event_card.errors)
          format.html { render action: "order_form", status: :unprocessable_entity }
          format.json { render json: @event_card.errors, status: :unprocessable_entity }
        end
      end
    end

    def choose_payment
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])
      redirected = check_order_state(@event_card)

      return if redirected

      set_checkout_reference(@event_card.checkout_reference)

      if session[:checkout_reference].nil?
        session[:checkout_reference] = @event_card.checkout_reference
      end

      @invoice = @event_card.to_invoice

      respond_to do |format|
          format.html
      end
    end

    def payment
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])

      if @event_card.order_state == 99
        redirect_to invalid_state_ef_event_cards_path
        return
      end

      @event_card.assign_attributes(event_card_params)

      @event_card.update_invoice.save

      if @event_card.payment_method == "credit_card"
        cc_payment(@event_card)
      elsif @event_card.payment_method == "direct_debit"
        dd_payment(@event_card)
      end
    end

    def confirm_dd_payment
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])
      @event_card.payment_method = "direct_debit"
      @event_card.update(event_card_params)

      if @event_card.valid?
        Rails.logger.debug("event card is valid in dd confirm")
        invoice = @event_card.to_invoice
        invoice.save
        @event_card.invoice_id = invoice.id
      else
          respond_to do |format|
          format.turbo_stream { render action: "payment", status: :unprocessable_entity }
          end
          return
      end

      if @event_card.save
          redirect_to payment_complete_ef_event_card_path(@event_card)
          return
      else
          Rails.logger.error(@event_card.errors)
          format.html { render action: "dd_payment", status: :unprocessable_entity }
      end

    end

    def payment_complete
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])

      if @event_card.payment_method == "credit_card"
        client = CorikaSumup::Client.new
        checkouts = client.get_checkouts(@event_card.checkout_reference)

        if checkouts.length >0
          checkout = checkouts.first

          @status = checkout["status"]
        end
      else
        # default status for dd payment
        @status = "PAID"
      end

      Rails.logger.debug("Payment complete: #{@status}")
      redirected = check_order_state(@event_card)
      return if redirected

      if @status == "PAID"
        @event_card.order_state = 99
        @event_card.save
        # remove checkout reference from session
        session[:checkout_reference] = nil
        EventCardOrderProcessingJob.perform_later(params[:checkout_reference])
      end

      respond_to do |format|
          format.html
      end
    end



    private

    def dd_payment(event_card)
    end

    def cc_payment(event_card)
      invoice = event_card.to_invoice
      invoice.save
      event_card.invoice_id = invoice.id
      event_card.save

      client = CorikaSumup::Client.new

      host_prefix = request.protocol+request.host

      cb_url = host_prefix+CorikaSumup::Engine.routes.url_helpers.callback_checkouts_path

      checkouts = client.get_checkouts(event_card.checkout_reference)

      if checkouts.length >0
        checkout = checkouts.first

        status = checkout["status"]
        checkout_id = checkout["id"]

        Rails.logger.info("Checkout exists - status: #{status}")

        if status == "EXPIRED"
          uuid = SecureRandom.uuid
          event_card.checkout_reference = uuid
          event_card.save
          Rails.logger.info("Existing checkout is expired, refresh checkout reference to #{uuid}")
        elsif status == "PAID"
          tx_id = checkout["transactions"].first["id"]
          Rails.logger.info("Payed with transaction: #{tx_id}")
          #event_card.transaction_id =
          redirect_to payment_complete_ef_event_card_path(@event_card)
          return
        else
          client.deactivate_checkout(checkout_id)
          Rails.logger.debug("Deactivated checkout #{checkout_id}")
        end
      end

      redirect_url = host_prefix+payment_complete_ef_event_card_path(event_card.checkout_reference)

      checkout_hash = client.create_checkout(amount: invoice.total, reference: event_card.checkout_reference, description: "Festivalkartenbestellung ##{event_card.id}", return_url: cb_url, redirect_url: redirect_url)

      if checkout_hash["error_code"].present?
        Rails.logger.error(checkout_hash)
        render :sumup_error, locals: { response: checkout_hash }
        return
      else
        checkout = CorikaSumup::Checkout.from_hash(checkout_hash)
        checkout.save
        event_card.checkout_id = checkout.checkout_id
        event_card.save
      end
    end

    private

    def event_card_params
      params.require(:event_card).permit(
        :email, :name, :email, :street, :zip, :city, :country_code, :preferred_lang,
        :nr_fest, :nr_fest_erm, :nr_fest_bdz, :nr_fest_bdz_erm, :nr_do, :nr_do_erm, :nr_fr, :nr_fr_erm, :nr_sa, :nr_sa_erm, :nr_concert_so, :nr_concert_so_erm, :iban, :bic, :account_owner, :bank_name, :payment_method)
    end

    private
    def set_event_card
      @event_card = EventCard.find_by(checkout_reference: params[:checkout_reference])
    end

    def event_card_from_session
      checkout_ref = session[:checkout_reference]

      event_card = nil

      if not checkout_ref.nil?
        Rails.logger.debug("Found stored checkout reference: #{checkout_ref}")
        event_card = EventCard.find_by(checkout_reference: checkout_ref)
      end

      event_card
    end

    def set_checkout_reference(ref)
      session[:checkout_reference] = ref
    end

    private
    def check_order_state(event_card)
      case event_card.order_state
        when 2
          return false
        when 99
          redirect_to invalid_state_ef_event_cards_path
          return true
        else
        return false
      end
      return false
    end
  end

end
