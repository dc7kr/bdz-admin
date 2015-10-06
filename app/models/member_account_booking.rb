class MemberAccountBooking < ActiveRecord::Base
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

	def self.newDistinctionInvoice(txt,amount,mglnrStr)
		return genericType(txt,'ehrungsrechnung','E',amount,mglnrStr)
	end

	def self.newInvoice(txt,amount,mglnrStr)
		return genericType(txt,'rechnung','B',amount,mglnrStr)
	end
	def self.newWithdrawal(txt,amount)
		@booking=MemberAccountBooking.new
		@booking.booking_date = Time.now
		@booking.booking_year = Time.now.year
		@booking.booking_txt = txt
		@booking.booking_mode='A'
		@booking.booking_type='L'
		@booking.amount=amount

		return @booking
	end

    def self.nonZeroBalance
      where('sum(amount)<0').group(:member_id)
    end

    comma :gema do
    end

  def self.unbalanced_for(year=nil)
    if not year.nil? 
      accounts = MemberAccountBooking.where("booking_year < ?", year).sum(:amount,:group=>:member_id)
    else
      accounts = MemberAccountBooking.sum(:amount,:group=>:member_id)
    end

    ids = Set.new
    accounts.each do |account|
      if account[1].round(2) <0 
          ids.add(account[0])
      end
	  end

    return { :accounts => accounts, :ids => ids }
  end
end

