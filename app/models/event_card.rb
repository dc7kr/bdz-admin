class EventCard < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :email, :email_format => true 
  validates_presence_of :name
  validates_presence_of :email
  validates_with EventCardValidator


  def total_card_count
    nr_fest+nr_fest_bdz+nr_do+nr_fr+nr_sa+nr_do_erm+nr_fr_erm+nr_sa_erm+nr_fest_erm+nr_fest_bdz_erm
  end
end
