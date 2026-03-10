class BicValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      return
    end

    # BIC is always 8 or 11 digits
    record.errors.add attribute, I18n.t("errors.bic.invalid_len") unless (value.length == 11 or value.length == 8)

    bank_code = value[0..3]
    country_code = value[4..5]
    location = value[6..7]

    Rails.logger.debug("BIC: #{bank_code}-#{country_code}-#{location}")

    if value.length == 11
      branch_code = value[8..10]
    end

    record.errors.add attribute, I18n.t("errors.bic.invalid_bank_code") unless /^[A-Z]+$/.match(bank_code)

    # only BIC lookup for DE works
    if country_code == "DE"
      record.errors.add attribute, I18n.t("errors.bic.unknown") unless BIC_FINDER.exist?(value)
    else
      # rest of the world: structural check...

      # valid country code?
      if  ISO3166::Country.new(country_code).nil?
        record.errors.add attribute, I18n.t("errors.bic.invalid_country")
      end
    end
  end
end

# Characters 1-4 (Bank Code): Four letters representing the institution.
# Characters 5-6 (Country Code): Two letters representing the ISO 3166-1 alpha-2 country code.
# Characters 7-8 (Location Code): Two characters (letters or numbers) indicating the bank's head office.
# Characters 9-11 (Branch Code - Optional): Three characters (letters or numbers) representing a specific branch. 'XXX' denotes the head office.
