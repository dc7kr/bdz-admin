class EventCardsMailer < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(card_data, cc)

    @card_data = card_data
	  mail(:to => @card_data.email, :cc => cc, :subject => t('event_cards_mailer.subject', :id => @card_data.id))
  end
 
end
