class GenericView < ActiveRecord::Base
  def self.public_views
    all = GenericView.connection.views

    view_names = Array.new
    
    all.each do |v|
      if v.start_with? "public"
        view_names << v.to_s.delete_prefix("public_")
      end
    end

    view_names
  end
end
