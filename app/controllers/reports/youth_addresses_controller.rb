require 'rodf'
module Reports
  class YouthAddressesController < AuthenticatedNonResourceController
    def index
      authorize! :orchestra, :edit
      @contacts = OrchestraContact.where("role  = 'J'").includes(:orchestra)

      respond_to do |format|
        format.ods do
          filename = '/tmp/jugendleiter.ods'
          renderYouthList(filename, @contacts)
          send_file(filename, filename: "#{Time.zone.now.year}_jugendleiter.ods", type: 'application/octet-stream')
        end
      end
    end

    def renderYouthList(filename, contacts)
      RODF::Spreadsheet.file(filename) do
        table 'Jugendleiter' do
          contacts.each do |c|
            row do
              cell c.orchestra.member.mglnr.to_s
              cell c.orchestra.orchName.to_s
              cell "#{c.first_name} #{c.last_name}"
              cell c.street
              cell c.zip
              cell c.city
              cell c.email
            end
          end
        end
      end
    end
  end
end
