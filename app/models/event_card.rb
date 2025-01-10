class EventCard < ApplicationRecord
  # attr_accessible :title, :body
  validates :email, email_format: true
  validates :name, presence: true
  validates :email, presence: true
  validates_with EventCardValidator

  def self.not_invoiced
    where(invoiced: 0)
  end

  def self.search(search)
    if search
      where('name like ? or id = ?', "%#{search}%", search)
    else
      where('1')
    end
  end

  def ordered_cards
    ordered = []
    prices = BDZ_SETTINGS['festival_prices']

    if nr_fest > 0
      c = OrderedCard.new(nr_fest, prices['fest'], 'fest')
      ordered << c
    end

    if nr_fest_erm > 0
      c = OrderedCard.new(nr_fest_erm, prices['fest_erm'], 'fest_erm')
      ordered << c
    end

    if nr_fest_bdz > 0
      c = OrderedCard.new(nr_fest_bdz, prices['fest_bdz'], 'fest_bdz')
      ordered << c
    end

    if nr_fest_bdz_erm > 0
      c = OrderedCard.new(nr_fest_bdz_erm, prices['fest_bdz_erm'], 'fest_bdz_erm')
      ordered << c
    end

    if nr_do > 0
      c = OrderedCard.new(nr_do, prices['tageskarte'], 'do')
      ordered << c
    end

    if nr_do_erm > 0
      c = OrderedCard.new(nr_do_erm, prices['tageskarte_erm'], 'do_erm')
      ordered << c
    end

    if nr_fr > 0
      c = OrderedCard.new(nr_fr, prices['tageskarte'], 'fr')
      ordered << c
    end

    if nr_fr_erm > 0
      c = OrderedCard.new(nr_fr_erm, prices['tageskarte_erm'], 'fr_erm')
      ordered << c
    end

    if nr_sa > 0
      c = OrderedCard.new(nr_sa, prices['tageskarte'], 'sa')
      ordered << c
    end

    if nr_sa_erm > 0
      c = OrderedCard.new(nr_sa_erm, prices['tageskarte_erm'], 'sa_erm')
      ordered << c
    end

    if nr_concert_so > 0
      c = OrderedCard.new(nr_concert_so, prices['concert'], 'concert_so')
      ordered << c
    end

    if nr_concert_so_erm > 0
      c = OrderedCard.new(nr_concert_so_erm, prices['concert_erm'], 'concert_so_erm')
      ordered << c
    end

    ordered
  end

  def total_card_count
    nr_fest + nr_fest_bdz + nr_do + nr_fr + nr_sa + nr_do_erm + nr_fr_erm + nr_sa_erm + nr_fest_erm + nr_fest_bdz_erm + nr_concert_so + nr_concert_so_erm
  end

  def sum
    prices = BDZ_SETTINGS['festival_prices']
    sum = 0
    sum += nr_fest * prices['fest']
    sum += nr_fest_erm * prices['fest_erm']
    sum += nr_fest_bdz * prices['fest_bdz']
    sum += nr_fest_bdz_erm * prices['fest_bdz_erm']
    sum += (nr_do + nr_fr + nr_sa) * prices['tageskarte']
    sum += (nr_do_erm + nr_fr_erm + nr_sa_erm) * prices['tageskarte_erm']
    sum += nr_concert_so * prices['concert']
    sum + (nr_concert_so_erm * prices['concert_erm'])
  end

  def invoice
    BDZ_SETTINGS['festival_prices']
    ts = Time.now.strftime '%Y%m%d'

    renr = ts + "-EC#{id}"

    invoice = CorikaInvoices::Invoice.new
    invoice.number = renr
    customer = to_customer
    invoice.customer = customer

    invoice.tax_type = 'B'

    prices = BDZ_SETTINGS['festival_prices']

    invoice.considerItem(nr_fest, prices['fest'], I18n.t('event_card.fest'))
    invoice.considerItem(nr_fest_erm, prices['fest_erm'], I18n.t('event_card.fest_erm'))
    invoice.considerItem(nr_fest_bdz, prices['fest_bdz'], I18n.t('event_card.fest_bdz'))
    invoice.considerItem(nr_fest_bdz_erm, prices['fest_bdz_erm'], I18n.t('event_card.fest_bdz_erm'))
    invoice.considerItem(nr_do, prices['tageskarte'], I18n.t('event_card.do'))
    invoice.considerItem(nr_fr, prices['tageskarte'], I18n.t('event_card.fr'))
    invoice.considerItem(nr_sa, prices['tageskarte'], I18n.t('event_card.sa'))
    invoice.considerItem(nr_do_erm, prices['tageskarte_erm'], I18n.t('event_card.do_erm'))
    invoice.considerItem(nr_fr_erm, prices['tageskarte_erm'], I18n.t('event_card.fr_erm'))
    invoice.considerItem(nr_sa_erm, prices['tageskarte_erm'], I18n.t('event_card.sa_erm'))
    invoice.considerItem(nr_concert_so, prices['concert'], I18n.t('event_card.concert_so'))
    invoice.considerItem(nr_concert_so_erm, prices['concert_erm'], I18n.t('event_card.concert_so_erm'))

    invoice
  end

  def has_email?
    !email.nil?
  end

  def to_customer
    cust = CorikaInvoices::Customer.new
    cust.customer_id
    cust.last_name

    cust.street = if street.nil?
                    '- via mail -'
                  else
                    street
                  end

    cust.zip = zip
    cust.city = city
    cust.country = country_code

    # cust.preferred_lang = preferred_lang

    cust.country = 'de' if email.end_with? '.de' or email.end_with? '.at'

    cust
  end

  def event_class
    # ContactEvent
    nil
  end
end
