require 'sepa_king'

class SepaTool
  attr_accessor :company, :bic, :iban, :creditor_id, :message_prefix

  def initialize(settings)
    @company = settings.company
    @bic = settings.bic
    @iban = settings.iban.gsub(/ /, '')
    @creditor_id = settings.creditor_id
    @message_prefix = settings.message_prefix

    return unless @message_prefix.nil?

    @message_prefix = 'KRI'
  end

  def create_sepa_direct_debit_order(direct_debits, requested_date = nil)
    requested_date = 5.days.from_now.to_date if requested_date.nil?

    sdd = SEPA::DirectDebit.new(
      name: @company,
      bic: @bic,
      iban: @iban,
      creditor_identifier: @creditor_id
    )

    # REQUIRES sepa_king > 0.1.0
    sdd.message_identification = "#{@message_prefix}/#{Time.now.to_i}"

    direct_debits.each do |dd|
      sdd.add_transaction(
        name: dd.name,
        bic: dd.bic,
        iban: dd.iban,
        amount: dd.amount,

        # OPTIONAL: End-To-End-Identification, will be submitted to the debtor
        # String, max. 35 char
        # reference:                 'XYZ/2013-08-ABO/6789',

        remittance_information: dd.remittance_txt,
        mandate_id: dd.mandate_id,
        mandate_date_of_signature: dd.sig_date,

        local_instrument: 'CORE',
        sequence_type: dd.sequence_type,
        requested_date: requested_date
        # OPTIONAL: Enables or disables batch booking, in German "Sammelbuchung / Einzelbuchung"
        # batch_booking: true
      )
    end

    sdd.to_xml
  end

  def create_credit_transfer(credit_transfers)
    # First: Create the main object
    sct = SEPA::CreditTransfer.new(
      name: @company,
      bic: @bic,
      iban: @iban
    )

    credit_transfers.each do |c|
      Rails.logger.debug { "Credit Transfer: #{c.iban} BIC: #{c.bic}" }
      # Second: Add transactions
      sct.add_transaction(
        name: c.customer.account_owner,
        bic: c.bic,
        iban: c.iban,
        amount: c.amount,

        # OPTIONAL: End-To-End-Identification, will be submitted to the creditor
        # String, max. 35 char
        # reference:              'XYZ-1234/123',

        # OPTIONAL: Unstructured remittance information, in German "Verwendungszweck"
        # String, max. 140 char
        remittance_information: c.remittance_txt
        # OPTIONAL: Requested execution date, in German "Ausführungstermin"
        # Date
        # requested_date: Date.new(2013,9,5),

        # OPTIONAL: Enables or disables batch booking, in German "Sammelbuchung / Einzelbuchung"
        # True or False
        # batch_booking: true,

        # service_level: 'URGP'
      )
    end

    sct.to_xml # Use latest schema pain.001.003.03
  end
end
