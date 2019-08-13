class DocumentsConfig
  attr_accessor  :work_dir, :template_dir, :archive_dir

  def initialize(hash) 

    if hash.nil? 
      throw :invoice_config_data_nil
    end

    hash.each do |k,v|
      if respond_to? "#{k}="
        public_send("#{k}=",v) 
      end
    end
  end
end
