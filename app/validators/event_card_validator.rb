class EventCardValidator < ActiveModel::Validator
  def validate(record)

    if not record.total_card_count.present? or record.total_card_count ==0
      record.errors.add(:base, :total_card_count_zero)
      return
    end

    if record.direct_debit?
      presence_or_error(record,:iban)
      presence_or_error(record,:bic)
      presence_or_error(record,:bank_name)
      presence_or_error(record,:account_owner)
    end
  end

  private
  def presence_or_error(record,sym)
    if not record[sym].present?
      record.errors.add(sym,:blank)
      false
    end

    true
  end
end
