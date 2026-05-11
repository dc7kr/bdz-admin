class TicketOrderSpreadsheet
  attr_accessor :event_cards, :sheet

  def initialize(event_cards)
    self.event_cards = event_cards
  end

  def render
    self.sheet = RODF::Spreadsheet.new
    t = self.sheet.table "Kartenbestellungen"
    t.row do
      cell I18n.t("common.number")
      cell I18n.t("event_card.name")
      cell I18n.t("event_card.email")
      cell I18n.t("event_card.fest")
      cell I18n.t("event_card.fest_erm")
      #cell I18n.t("event_card.fest_bdz")
      #cell I18n.t("event_card.fest_bdz_erm")
      cell I18n.t("event_card.do")
      cell I18n.t("event_card.do_erm")
      cell I18n.t("event_card.fr")
      cell I18n.t("event_card.fr_erm")
      cell I18n.t("event_card.sa")
      cell I18n.t("event_card.sa_erm")
    end

    self.event_cards.each do |event_card|
      t.row do
        cell event_card.id
        cell event_card.name
        cell event_card.email
        cell event_card.nr_fest
        cell event_card.nr_fest_erm
        #cell event_card.nr_fest_bdz
        #cell event_card.nr_fest_bdz_erm
        cell event_card.nr_do
        cell event_card.nr_do_erm
        cell event_card.nr_fr
        cell event_card.nr_fr_erm
        cell event_card.nr_sa
        cell event_card.nr_sa_erm
      end
    end
  end

  def bytes
    self.sheet.bytes
  end
end
