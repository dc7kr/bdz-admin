class DocumentsConfig
  attr_accessor :work_dir, :template_dir, :archive_dir, :pdftk

  def initialize(hash)
    throw :invoice_config_data_nil if hash.nil?

    hash.each do |k, v|
      public_send("#{k}=", v) if respond_to? "#{k}="
    end
  end
end
