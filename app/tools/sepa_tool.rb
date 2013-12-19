class SEPATool

  def create_party(contact) 
    Sepa::DirectDebitOrder::Party.new(
      BDZ_SETTINGS["company"], 
      contact["street"] , 
      nil, 
      contact["plz"], 
      contact["ort"], 
      "Deutschland", 
      contact["name"], 
      contact["phone"],
      contact["email"] 
    )
  end

  def create_sepa_direct_debit_order direct_debits, message_id, payment_identifier, collection_date
    dd_list = []

    direct_debits.each do |dd|
      bank_account = Sepa::DirectDebitOrder::BankAccount.new dd.iban, dd.bic
      debtor = Sepa::DirectDebitOrder::Party.new dd.name, dd.addr, nil, dd.postcode, dd.town, dd.country, dd.contact, dd.phone, dd.email
      mandate = Sepa::DirectDebitOrder::MandateInformation.new dd.mandate_id, dd.sig_date, dd.sequence_type
      dd_list << Sepa::DirectDebitOrder::DirectDebit.new(debtor, bank_account, dd.end_to_end_id, dd.amount, "EUR", mandate)
    end

    bdz_contact = BDZ_SETTINGS["contacts"]["gs"]

    creditor = create_party(bdz_contact)
    creditor_account = Sepa::DirectDebitOrder::BankAccount.new BDZ_SETTINGS["iban"], BDZ_SETTINGS["bic"]
    sepa_identifier = Sepa::DirectDebitOrder::PrivateSepaIdentifier.new BDZ_SETTINGS["creditor_id"]

    payment = Sepa::DirectDebitOrder::CreditorPayment.new(
      creditor, 
      creditor_account,  
      payment_identifier,  # TODO! 
      collection_date,      
      sepa_identifier, 
      dd_list
    )

    bdz_contact = BDZ_SETTINGS["contacts"]["gs"]

    initiator = create_party(bdz_contact)

    order = Sepa::DirectDebitOrder::Order.new message_id, initiator, [payment]

    order.to_xml pain_008_001_version: "04"
  end
end
