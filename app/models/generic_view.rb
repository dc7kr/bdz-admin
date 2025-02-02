class GenericView < ApplicationRecord
  def self.public_views
    all = GenericView.connection.views

    view_names = []

    all.each do |v|
      view_names << v.to_s.delete_prefix('public_') if v.start_with? 'public'
    end

    view_names
  end
end
