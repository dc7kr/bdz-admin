module FestivalTicketHelper
def consider_regular_tickets(invoice, count)
    prices = BDZ_SETTINGS["festival_prices"]

    item = invoice.consider_item(count, prices["ticket_entry"]+prices["ticket_food"]+prices["ticket_drink"], I18n.t("event_card.fest"), tax_rate: 7)

    if item.present?
      item.item_taxes.clear()
      item.add_split_tax(7,prices["ticket_food"], I18n.t("event_card.food_part"))
      item.add_split_tax(19, prices["ticket_drink"], I18n.t("event_card.drink_part"))
      item.add_split_tax(7, prices["ticket_entry"], I18n.t("event_card.ticket_part"))
    end

    item
end

def consider_reduced_tickets(invoice, count)
    prices = BDZ_SETTINGS["festival_prices"]

    item = invoice.consider_item(count, prices["ticket_entry_red"]+prices["ticket_food"]+prices["ticket_drink"], I18n.t("event_card.fest_erm"), tax_rate: 7)
    if item.present?
      item.item_taxes.clear()
      item.add_split_tax(7,prices["ticket_food"], I18n.t("event_card.food_part"))
      item.add_split_tax(19, prices["ticket_drink"], I18n.t("event_card.drink_part"))
      item.add_split_tax(7, prices["ticket_entry_red"], I18n.t("event_card.ticket_part"))
    end

    item
end


end
