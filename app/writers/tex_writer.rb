class TexWriter
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  @@workdir = DOCS_CONFIG.work_dir

  def self.workdir
    @@workdir
  end

  def write_invoice(invoice, contact, year)
    File.open("#{TexWriter.workdir}/variables.tex", 'w') do |file_handle|
      write_our_data(file_handle, contact)
      write_common(file_handle, invoice.customer)
      file_handle.write("\\newcommand{\\jahr}{#{year}}\n")
      file_handle.write("\\newcommand{\\renummer}{#{invoice.number}}\n")
      file_handle.write("\\newcommand{\\zweck}{#{invoice.number}}\n")
    end
    File.open("#{TexWriter.workdir}/posten.tex", 'w') do |file_handle|
      invoice.items.each do |item|
        write_invoice_item(file_handle, item.count, item.price, item.label)
        Rails.logger.debug { "wrote tariff comp: #{item.count}x#{item.price}:#{item.label}" }
      end
    end
  end

  def write_invoice_item(file, count, tariff, label)
    if count.nil? || count.zero?
      Rails.logger.info("omitting #{label} item as count was nil or 0")
      return
    end
    amount = '%.2f' % tariff
    amount = amount.gsub('.', ',')

    if tariff.negative?
      file.write("\\Anzahlung{#{amount}}\n")
    else
      file.write("\\Artikel{#{String(count)}}{#{label}}{#{amount}}\n")
    end
  end

  def write_person_tariff(person)
    File.open("#{TexWriter.workdir}/posten.tex", 'w') do |file_handle|
      write_invoice_item(file_handle, 1, person.tariff.amount, "Beitrag #{person.tariff.description}")
    end
  end

  def write_report_sheet_reminder_data(customer)
    File.open("#{TexWriter.workdir}/variables.tex", 'w') do |file_handle|
      write_our_data(file_handle, 'gs')
      write_common(file_handle, customer)
      intwo = I18n.l(14.days.from_now.to_date, format: :long)
      file_handle.write("\\newcommand{\\inTwoWeeks}{#{intwo}}\n")
    end
  end

  def write_reminder_data(customer, bookings)
    File.open("#{TexWriter.workdir}/variables.tex", 'w') do |file_handle|
      write_our_data(file_handle, 'treasurer')
      write_common(file_handle, customer)
      intwo = I18n.l(14.days.from_now.to_date, format: :long)
      file_handle.write("\\newcommand{\\inTwoWeeks}{#{intwo}}\n")
    end

    File.open("#{TexWriter.workdir}/bookings.tex", 'w') do |file_handle|
      @last = nil
      sum = 0
      bookings.each do |booking|
        file_handle.write(format_date(booking.booking_date) + '&' + booking.booking_txt + ' &  ' + format_currency(booking.amount,
                                                                                                         'EUR') + "\\\\\n")
        sum += booking.amount unless booking.amount.nil?
      end
      file_handle.write("\\hline\n")
      file_handle.write("\\textbf{Summe} & & \\textbf{#{format_currency(sum, 'EUR')}}\\\\\n")
    end
  end

  def write(member, year)
    File.open("#{TexWriter.workdir}/variables.tex", 'w') do |file_handle|
      write_our_data(file_handle, 'gs')
      file_handle.write("\\newcommand{\\jahr}{#{year}}\n")
      write_common(file_handle, member.to_customer)
    end
  end

  def write_common(file_handle, customer)
    file_handle.write("\\newcommand{\\mglnr}{#{customer.customer_id}}\n")
    if customer.is_direct_debit?
      file_handle.write("\\newcommand{\\directDebit}{1}\n")
      file_handle.write("\\newcommand{\\iban}{#{customer.iban}}\n")
      file_handle.write("\\newcommand{\\bic}{#{customer.bic}}\n")

      file_handle.write("\\newcommand{\\mandateRef}{#{customer.mandate_id}}\n")
      file_handle.write("\\newcommand{\\glaeubigerId}{#{BDZ_SETTINGS['invoice_config']['creditor_id']}}\n")
    else
      file_handle.write("\\newcommand{\\directDebit}{0}\n")
    end
    if customer.company.nil?
      file_handle.write("\\newcommand{\\firma}{}\n")
    else
      file_handle.write("\\newcommand{\\firma}{#{break_name(tex_escape(customer.company))}}\n")
    end
    file_handle.write("\\newcommand{\\name}{#{customer.full_name}}\n")
    file_handle.write("\\newcommand{\\strasse}{#{customer.street}}\n")
    full_ort = ''
    if customer.zip
      full_ort += customer.zip
      full_ort += ' '
    end
    full_ort += customer.city if customer.city

    file_handle.write("\\newcommand{\\ort}{#{full_ort}}\n")

    country = ISO3166::Country[customer.country]
    country_en = if customer.country == 'DE'
                   ''
                 else
                   country.translations['en']
                 end

    file_handle.write("\\newcommand{\\country}{#{country_en}}\n")
    if customer.last_name
      if customer.salutation == 'Herr'
        file_handle.write("\\newcommand{\\anredetxt}{r Herr #{customer.last_name}}\n")
      elsif customer.salutation == 'Frau'
        file_handle.write("\\newcommand{\\anredetxt}{ Frau #{customer.last_name}}\n")
      else
        file_handle.write("\\newcommand{\\anredetxt}{ Damen und Herren}\n")
      end
    else
      file_handle.write("\\newcommand{\\anredetxt}{ Damen und Herren,}\n")
    end
    # file_handle.write('\newcommand{\myStrasse}{}'+"\n")
    file_handle.write("\\newcommand{\\redatum}{#{I18n.l(Time.zone.now.to_date, format: :long)}}\n")
  end

  def write_our_data(file_handle, contact)
    our_contact = BDZ_SETTINGS['contacts'][contact]
    invoice_config = BDZ_SETTINGS['invoice_config']

    file_handle.write("\\newcommand{\\myFirma}{#{invoice_config['company']}}\n")
    file_handle.write("\\newcommand{\\myFirmaShort}{#{invoice_config['company_short']}}\n")
    file_handle.write("\\newcommand{\\myKonto}{#{invoice_config['konto']}}\n")
    file_handle.write("\\newcommand{\\myBLZ}{#{invoice_config['blz']}}\n")
    if our_contact['iban'].nil?
      file_handle.write("\\newcommand{\\myBank}{#{invoice_config['bank']}}\n")
      file_handle.write("\\newcommand{\\myIBAN}{#{invoice_config['iban']}}\n")
      file_handle.write("\\newcommand{\\myBIC}{#{invoice_config['bic']}}\n")
    else
      file_handle.write("\\newcommand{\\myIBAN}{#{our_contact['iban']}}\n")
      file_handle.write("\\newcommand{\\myBIC}{#{our_contact['bic']}}\n")
      file_handle.write("\\newcommand{\\myBank}{#{our_contact['bank']}}\n")
    end

    file_handle.write("\\newcommand{\\myPhone}{#{our_contact['phone']}}\n")
    file_handle.write("\\newcommand{\\myFax}{#{our_contact['fax']}}\n")
    file_handle.write("\\newcommand{\\myMail}{#{our_contact['mail']}}\n")
    file_handle.write("\\newcommand{\\myName}{#{our_contact['name']}}\n")
    file_handle.write("\\newcommand{\\myDept}{#{our_contact['dept']}}\n")
    file_handle.write("\\newcommand{\\myStreet}{#{our_contact['street']}}\n")
    file_handle.write("\\newcommand{\\myPLZ}{#{our_contact['zip']}}\n")
    file_handle.write("\\newcommand{\\myOrt}{#{our_contact['city']}}\n")
    file_handle.write("\\newcommand{\\myJob}{#{our_contact['job']}}\n")
  end

  def break_name(name)
    # if name contains ; use that...
    name.gsub(';', '\\\\ ')
  end

  def format_date(date)
    I18n.l(date.to_date, format: :long)
  end

  def format_currency(val, _currency)
    number_to_currency(val, locale: :de)
  end

  def move_generated_files(date_prefix)
    work_dir = DOCS_CONFIG.work_dir
    archive_dir = DOCS_CONFIG.archive_dir
    target_dir = "#{archive_dir}/#{String(Time.zone.now.year)}"

    shortprefix = Time.zone.now.strftime('%Y%m%d-')

    FileUtils.mkdir_p target_dir

    Dir.chdir(work_dir)
    Dir.entries(work_dir).each do |file|
      FileUtils.mv file, "#{target_dir}/" if file.start_with?(date_prefix) || file.start_with?(shortprefix)
    end
  end

  def gen_pdf(invoice_type, date_prefix, customer_id)
    out_file = "#{date_prefix}-#{customer_id}-#{invoice_type}.pdf"
    tool_dir = INVOICE_CONFIG.tool_dir
    system("#{tool_dir}/bin/rechnung.sh #{invoice_type} #{date_prefix} #{customer_id}")

    out_file
  end

  def tex_escape(text)
    text.gsub(/"([a-zA-z0-9]+)"/, '\glqq \1\grqq ')
  end
end
