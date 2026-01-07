module Adm
  class InvoiceCheckController < AuthenticatedController
    skip_after_action :verify_pundit_authorization
    def index
      authorize :admin, :show?
    end

    def distinction
      authorize :admin, :show?

      distinction = Distinction.new

      distinction.certificates = 1
      distinction.silver_needles = 2
      distinction.gold_needles = 3
      distinction.honorletters = 4
      distinction.medals = 5
      distinction.national_needles = 6
      distinction.porto = 3.45

      orchestra = policy_scope(Member).where("mglnr = 1045").first.member_entity
      authorize orchestra, :show?

      distinction.orchestra = orchestra

      invoice = distinction.gen_invoice

      pdf = invoice.gen_pdf(true)

      send_file(pdf.full_path, filename: "test_ehrungsrechnung.pdf", type: "application/octet-stream")
    end

    def orchestra
      authorize :admin, :show?
      orch = policy_scope(Orchestra).joins(:member).where("members.mglnr = 1045").first

      year = orch.report_sheets.last.year
      invoice = orch.gen_invoice(year)

      pdf = invoice.gen_pdf(true)

      send_file(pdf.full_path, filename: "test_beitragsrechnung.pdf", type: "application/octet-stream")
    end

    def person_member
      authorize :admin, :show?
      pm = PersonMember.last
      invoice = pm.gen_invoice(Time.zone.now.year)
      pdf = invoice.gen_pdf(true)

      send_file(pdf.full_path, filename: "test_em_beitragsrechnung.pdf", type: "application/octet-stream")
    end
  end
end
