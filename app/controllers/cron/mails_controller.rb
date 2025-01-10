require 'mail'

class Cron::MailsController < ApplicationController
  load_and_authorize_resource

  def index
    # address = Mail::Address.new email # ex: "john@example.com"
    # address.display_name = name # ex: "John Doe"
    ## Set the From or Reply-To header to the following:
    # address.format # returns "John Doe <john@example.com>"

    @users = User.where('role like ?', '%admin%')
    base_url = cron_downloads_url
    invoices_url = base_url + '?year=2012&filename=20120529-rechnung_merge.pdf'
    dtaus_url = base_url + '?year=2012&filename=20120529_dtaus.zip'

    @users.each do |user|
      AdminNotifier.newinvoices_notification(user, invoices_url, dtaus_url).deliver
      puts 'sent to %s' % current_user.email
    end
  end
end
