class EventCardsMailer < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(card_data, cc)

    @card_data = card_data
	  mail(:to => @card_data.email, :cc => cc, :subject => "Ihre Kartenbestellung Nr. #{@card_data.id} fuer das Eurofestival 2014");
  end
 
end
