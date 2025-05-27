class BatchController < AuthenticatedController
  def check_token(token)
    expected = "4f70968b8cffde36c5c9f1cc7183edcf4bc2f752"

    token == expected
  end

  def cancellations
    unless check_token(params[:token])
      render text: "EAUTH"
      Rails.logger.info("Authentication failure on batch controller")
      return
    end
    @orchestras = Orchestra.cancelled
    @persons = PersonMember.cancelled

    @count = { "orch" => @orchestras.size, "em" => @persons.size }

    txt = "Automatische Austritte:\n"
    txt += "#{@count['em']} Einzelmitglieder:\n"

    @persons.each do |p|
      txt += "#{p.fullname}\n"
      Rails.logger.info("Austritt: #{p.fullname}")
      p.destroy
    end

    txt += "#{@count['orch']} Orchester\n"

    @orchestras.each do |o|
      txt += "#{o.orchName}\n"
      Rails.logger.info("Austritt: #{o.orchName}")
      o.destroy
    end

    respond_to do |format|
      format.html { render text: txt }
    end
  end
end
