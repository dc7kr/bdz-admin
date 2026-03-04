module Ef
  class EventCardsController < Ef::ApplicationController
    include ::ApplicationHelper
    helper ::FontAwesomeHelper

    helper_method :entity_row

    before_action :set_event_card

    def order_form
      @event_card = EventCard.new
      @event_card.country_code = "DE"
      @prices = BDZ_SETTINGS["festival_prices"]
    end

    def order
      @event_card = EventCard.new(event_card_params)
      @prices = BDZ_SETTINGS["festival_prices"]

      @event_card.festival_year = BDZ_SETTINGS["config"]["festival_year"]
      @event_card.orderdate = Time.zone.now

      uuid = SecureRandom.uuid
      @event_card.checkout_reference = uuid

      if @event_card.save
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
      @invoice = @event_card.to_invoice

      respond_to do |format|
          format.html
        end

    end

    def payment
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])
      @event_card.update(event_card_params)

      Rails.logger.debug(event_card_params)
      Rails.logger.debug(@event_card.payment_method)
      Rails.logger.debug(@event_card.valid?)
      @event_card.save

      if @event_card.payment_method == "credit_card"
        cc_payment(@event_card)
      elsif @event_card.payment_method == "direct_debit"
        dd_payment(@event_card)
      end
    end

    def confirm_dd_payment
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])
      @event_card.update(event_card_params)

      invoice = @event_card.to_invoice
      invoice.save
      @event_card.invoice_id = invoice.id

      if @event_card.save
          redirect_to payment_complete_ef_event_card_path(@event_card)
          return
      else
          format.html { render action: "dd_payment", status: :unprocessable_entity }
      end

    end

    def payment_complete
      @event_card = EventCard.find_by_checkout_reference(params[:checkout_reference])

      EventCardOrderProcessingJob.perform_later(params[:checkout_reference])

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

    def set_event_card
      @event_card = EventCard.find_by(checkout_reference: params[:checkout_reference])
    end
  end
end
