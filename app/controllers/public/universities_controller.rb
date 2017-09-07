class Public::UniversitiesController < ApplicationController
  def index
    universities_de = University.where(:country_code=>'de').order(:country_code,:plz)

    universities_other = University.where("country_code <> 'de'").order(:country_code,:plz)

    @universities = Hash.new

    @locale = I18n.locale

    @universities["de"]= universities_de

    universities_other.each do |u|
      u_list = nil
      if @universities[u.country_code].nil? then
        u_list = Array.new
        @universities[u.country_code]=u_list;
      else
        u_list = @universities[u.country_code]
      end 
      
      u_list << u
    end
  end
end
