class MemberAccountBooking < ApplicationRecord
	belongs_to :member
  validates_presence_of :amount,:booking_txt

    def has_reference?
        return ref_booking_id != nil 
    end
	def has_attachment?
		filename != nil and filename.length()>0
    end

	def self.genericType(txt,prefix,type,amount,mglnrStr)
		@booking=MemberAccountBooking.new
		@booking.booking_date = Time.now
		@booking.booking_year = Time.now.year
		@booking.booking_txt = txt
		@booking.booking_mode='A'
		@booking.booking_type=type
		@booking.amount=amount

		@dateprefix = Time.now.strftime '%Y%m%d'
		
		@booking.filename = @dateprefix+"-"+prefix+mglnrStr+".pdf"

		return @booking
  end

	def self.newDistinctionInvoice(txt,amount,mglnrStr,pdf)
		booking = genericType(txt,'ehrungsrechnung','E',amount,mglnrStr)

    booking.filename=pdf.orig_filename

    booking
	end

	def self.newInvoice(txt,amount,mglnrStr)
		return genericType(txt,'rechnung','B',amount,mglnrStr)
	end
	def self.newWithdrawal(txt,amount,filename=nil)
		booking=MemberAccountBooking.new
		booking.booking_date = Time.now
		booking.booking_year = Time.now.year
		booking.booking_txt = txt
		booking.booking_mode='A'
		booking.booking_type='L'
		booking.amount=amount
    booking.filename=filename

		return booking
	end

	def self.newCreditTransfer(txt,amount)
		booking=MemberAccountBooking.new
		booking.booking_date = Time.now
		booking.booking_year = Time.now.year
		booking.booking_txt = txt
		booking.booking_mode='A'
		booking.booking_type='G'
		booking.amount=amount

		return booking
	end
    def self.nonZeroBalance
      where('sum(amount)<0').group(:member_id)
    end

    comma :gema do
    end

  def self.balanced_before(year=nil)
    if not year.nil? 
      accounts = MemberAccountBooking.where("booking_year < ?", year).group(:member_id).sum(:amount)
    else
      accounts = MemberAccountBooking.group(:member_id).sum(:amount)
    end

    ids = Set.new
    accounts.each do |account|
      if account[1].round(2) >-0.1
          ids.add(account[0])
      end
	  end

    return { :accounts => accounts, :ids => ids }
  end

  def self.unbalanced_before_year(year=nil,lv=nil)
    if not year.nil? 
      accounts = MemberAccountBooking.where("booking_year < ?", year).group(:member_id).sum(:amount)
    else
      accounts = MemberAccountBooking.group(:member_id).sum(:amount)
    end

    ids = Set.new
    lv_ids = nil

    if not lv.nil?
            lv_ids = Member.where("regional_organization_id = ?",lv.id).map { |pm| pm.id}
    end
    accounts.each do |account|
      if account[1].round(2) <-0.1
          if lv_ids.nil? or lv_ids.include? account[0]
            ids.add(account[0])
          end

          Rails.logger.debug("Amount: #{account[1].round(2)} ID: #{account[0]}")
      end
	  end

    return { :accounts => accounts, :ids => ids }
  end

  def self.booking_types
    ["A","B","L","G","E","R","S","Z"]
  end

  def member_type 
      clazz = member.member_entity.class
      if clazz == PersonMember
        :person_member
      elsif clazz == Orchestra
        :orchestra
      elsif clazz == RegionalOrganizatioon
        :regional_organization
      else
        nil
      end
  end
end
