module Adm
  class InvoiceCheckController < AuthenticatedNonResourceController
    def index
      authorize! :member, :edit
    end

    def distinction
      authorize! :member, :edit

      distinction = Distinction.new

      distinction.certificates = 1
      distinction.silver_needles = 2
      distinction.gold_needles = 3
      distinction.honorletters = 4
      distinction.medals = 5
      distinction.national_needles = 6
      distinction.porto = 3.45

      orchestra = Member.where("mglnr = 1045").first.member_entity
      distinction.orchestra = orchestra

      invoice = distinction.gen_invoice

      pdf = invoice.gen_pdf(true)

      send_file(pdf.full_path, filename: "test_ehrungsrechnung.pdf", type: "application/octet-stream")
    end

    def orchestra
      authorize! :member, :edit
      orch = Orchestra.joins(:member).where("members.mglnr = 1045").first

      invoice = orch.gen_invoice(Time.zone.now.year)

      pdf = invoice.gen_pdf(true)

      send_file(pdf.full_path, filename: "test_beitragsrechnung.pdf", type: "application/octet-stream")
    end

    def person_member
      authorize! :member, :edit
      pm = PersonMember.last
      invoice = pm.gen_invoice(Time.zone.now.year)
      pdf = invoice.gen_pdf(true)
      
      send_file(pdf.full_path, filename: "test_em_beitragsrechnung.pdf", type: "application/octet-stream")
    end
  end
end
