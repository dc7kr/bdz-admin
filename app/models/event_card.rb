class EventCard < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :email, :email_format => true 
  validates_presence_of :name
  validates_presence_of :email
  validates_with EventCardValidator


  def ordered_cards
    ordered = Array.new
    prices = BDZ_SETTINGS["festival_prices"]

    if ( nr_fest > 0) then
      c = OrderedCard.new(nr_fest,prices["fest"],"fest")
      ordered << c
    end

    if ( nr_fest_erm > 0) then
      c = OrderedCard.new(nr_fest_erm,prices["fest_erm"],"fest_erm")
      ordered << c
    end

    if ( nr_fest_bdz > 0) then
      c = OrderedCard.new(nr_fest_bdz,prices["fest_bdz"],"fest_bdz")
      ordered << c
    end

    if ( nr_fest_bdz_erm > 0) then
      c = OrderedCard.new(nr_fest_bdz_erm,prices["fest_bdz_erm"],"fest_bdz_erm")
      ordered << c
    end

    if ( nr_do > 0 ) then
      c = OrderedCard.new(nr_do,prices["tageskarte"],"do")
      ordered << c
    end

    if ( nr_do_erm > 0 ) then
      c = OrderedCard.new(nr_do_erm,prices["tageskarte_erm"],"do_erm")
      ordered << c
    end

    if ( nr_fr > 0 ) then
      c = OrderedCard.new(nr_fr,prices["tageskarte"],"fr")
      ordered << c
    end

    if ( nr_fr_erm > 0 ) then
      c = OrderedCard.new(nr_fr_erm,prices["tageskarte_erm"],"fr_erm")
      ordered << c
    end

    if ( nr_sa > 0 ) then
      c = OrderedCard.new(nr_sa,prices["tageskarte"],"sa")
      ordered << c
    end
    
    if ( nr_sa_erm > 0 ) then
      c = OrderedCard.new(nr_sa_erm,prices["tageskarte_erm"],"sa_erm")
      ordered << c
    end


    if ( nr_concert_so > 0 ) then
      c = OrderedCard.new(nr_concert_so,prices["concert"],"concert_so")
      ordered << c
    end
    
    if ( nr_concert_so_erm > 0 ) then
      c = OrderedCard.new(nr_concert_so_erm,prices["concert_erm"],"concert_so_erm")
      ordered << c
    end

    ordered
  end


  def total_card_count
    nr_fest+nr_fest_bdz+nr_do+nr_fr+nr_sa+nr_do_erm+nr_fr_erm+nr_sa_erm+nr_fest_erm+nr_fest_bdz_erm+nr_concert_so+nr_concert_so_erm
  end

  def sum
    prices = BDZ_SETTINGS["festival_prices"]
    sum=0
    sum += nr_fest*prices["fest"]
    sum += nr_fest_erm*prices["fest_erm"]
    sum += nr_fest_bdz*prices["fest_bdz"]
    sum += nr_fest_bdz_erm*prices["fest_bdz_erm"]
    sum += (nr_do+nr_fr+nr_sa)*prices["tageskarte"]
    sum += (nr_do_erm+nr_fr_erm+nr_sa_erm)*prices["tageskarte_erm"]
    sum += nr_concert_so*prices["concert"]
    sum += nr_concert_so_erm*prices["concert_erm"]
  end
end
