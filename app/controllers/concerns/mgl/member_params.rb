module Mgl
  # Contact and payment data of the Member record that members may change themselves.
  # Membership data (mglnr, regional organization, dates, magazines, SEPA mandate)
  # stays with the office.
  module MemberParams
    extend ActiveSupport::Concern

    MEMBER_ATTRIBUTES = %i[anrede title vorname name strasse plz ort country_code email telefon fax
                           za zahler iban bic].freeze

    private

    # The member is passed separately instead of nested attributes, so a
    # tampered member id can never point to another member.
    # Like in the report sheet input wizard, members paying by invoice may switch
    # to direct debit but not the other way round.
    def member_params
      permitted = params.require(:member).permit(*MEMBER_ATTRIBUTES)
      permitted.delete(:za) unless @member.za == "R" && %w[L R].include?(permitted[:za])
      permitted
    end

    def save_with_member(entity)
      saved = false
      ActiveRecord::Base.transaction do
        saved = entity.save & entity.member.save
        raise ActiveRecord::Rollback unless saved
      end
      saved
    end
  end
end
