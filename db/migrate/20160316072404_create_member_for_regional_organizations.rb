class CreateMemberForRegionalOrganizations < ActiveRecord::Migration
  def up
    RegionalOrganization.all.each do |r|
      if r.nummer == 0 or not r.member.nil? then
        p "Skipped: #{r.id}"
        next
      end

      f = Function.where("regional_organization_id = ? and nr=1",r.id);

      contact = nil
      if f.count > 0 then
        bc = f.first.board_contact
        if not bc.nil? then 
          contact = f.first.board_contact.contact
        end
      end

      if contact.nil? then 
        contact = Contact.new
        contact.salutation= "M"
        contact.first_name = "DUMMY"
        contact.last_name = "DUMMY"
        contact.street = "Dummy"
        contact.city= "Dummy"
        contact.zip= "Dummy"
        contact.country_code= "de"
      end

      member = Member.new
      member.member_entity = r
      member.mglnr = "#{r.nummer}000"
      member.iban = r.iban
      member.bic = r.bic
      member.eintritt = Date.new 
      member.name = contact.last_name
      member.vorname = contact.first_name
      member.anrede = contact.salutation
      member.strasse = contact.street
      member.plz= contact.zip
      member.ort= contact.city
      member.regional_organization = r
      member.subtype="RegionalOrganization"
      member.za="R"
      if not member.save then
        fail member.errors.full_messages.join("\n")
      end
    end
  end

  def down
  end
end
