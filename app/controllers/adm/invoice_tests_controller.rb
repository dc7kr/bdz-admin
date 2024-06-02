class Adm::InvoiceTestsController < AuthenticatedNonResourceController

  def index
    authorize! :member, :edit
  end

  def distinction_invoice
    authorize! :member, :edit
  end

  def member_fee_invoice
    authorize! :member, :edit
  end
end
