class MemberAccountBooking < ApplicationRecord
  belongs_to :member
  validates :amount, :booking_txt, presence: true

  def has_reference?
    !ref_booking_id.nil?
  end

  def has_attachment?
    !filename.nil? and filename.length.positive?
  end

  def self.genericType(txt, prefix, type, amount, mglnrStr)
    @booking = MemberAccountBooking.new
    @booking.booking_date = Time.zone.now
    @booking.booking_year = Time.zone.now.year
    @booking.booking_txt = txt
    @booking.booking_mode = 'A'
    @booking.booking_type = type
    @booking.amount = amount

    @dateprefix = Time.zone.now.strftime '%Y%m%d'

    @booking.filename = "#{@dateprefix}-#{prefix}#{mglnrStr}.pdf"

    @booking
  end

  def self.new_distinction_invoice(txt, amount, mglnrStr, pdf)
    booking = genericType(txt, 'ehrungsrechnung', 'E', amount, mglnrStr)

    booking.filename = pdf.orig_filename

    booking
  end

  def self.new_invoice(txt, amount, mglnrStr)
    genericType(txt, 'rechnung', 'B', amount, mglnrStr)
  end

  def self.new_dd(txt, amount, filename = nil)
    booking = MemberAccountBooking.new
    booking.booking_date = Time.zone.now
    booking.booking_year = Time.zone.now.year
    booking.booking_txt = txt
    booking.booking_mode = 'A'
    booking.booking_type = 'L'
    booking.amount = amount
    booking.filename = filename

    booking
  end

  def self.new_credit_transfer(txt, amount)
    booking = MemberAccountBooking.new
    booking.booking_date = Time.zone.now
    booking.booking_year = Time.zone.now.year
    booking.booking_txt = txt
    booking.booking_mode = 'A'
    booking.booking_type = 'G'
    booking.amount = amount

    booking
  end

  def self.nonZeroBalance
    where('sum(amount)<0').group(:member_id)
  end

  comma :gema do
  end

  def self.balanced_before(year = nil)
    accounts = if year.nil?
                 MemberAccountBooking.group(:member_id).sum(:amount)
               else
                 MemberAccountBooking.where(booking_year: ...year).group(:member_id).sum(:amount)
               end

    ids = Set.new
    accounts.each do |account|
      ids.add(account[0]) if account[1].round(2) > -0.1
    end

    { accounts: accounts, ids: ids }
  end

  def self.unbalanced_before_year(year = nil, lv = nil)
    accounts = if year.nil?
                 MemberAccountBooking.group(:member_id).sum(:amount)
               else
                 MemberAccountBooking.where(booking_year: ...year).group(:member_id).sum(:amount)
               end

    ids = Set.new
    lv_ids = nil

    lv_ids = Member.where(regional_organization_id: lv.id).map(&:id) unless lv.nil?
    accounts.each do |account|
      next unless account[1].round(2) < -0.1

      ids.add(account[0]) if lv_ids.nil? || lv_ids.include?(account[0])

      Rails.logger.debug { "Amount: #{account[1].round(2)} ID: #{account[0]}" }
    end

    { accounts: accounts, ids: ids }
  end

  def self.booking_types
    %w[A B L G E R S Z]
  end

  def member_type
    clazz = member.member_entity.class
    if clazz == PersonMember
      :person_member
    elsif clazz == Orchestra
      :orchestra
    elsif clazz == RegionalOrganizatioon
      :regional_organization
    end
  end
end
