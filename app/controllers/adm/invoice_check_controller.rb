class Adm::InvoiceCheckController < AuthenticatedNonResourceController

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

    pdf = invoice.gen_pdf

  end

  def orchestra
    authorize! :member, :edit
    rs = Orchestra.joins(:member).where("members.mglnr = 1045").first.report_sheets.last
    invoice = rs.gen_invoice

    tw = CorikaInvoices::TexWriter.new(INVOICE_CONFIG)
    pdf = invoice.gen_pdf(tw)

    send_file(pdf, :filename => "test_rs.pdf", :type => "application/octet-stream")
  end

  def person_member
    authorize! :member, :edit
  end
end
