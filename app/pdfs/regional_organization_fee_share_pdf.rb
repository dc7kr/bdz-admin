require 'prawn'
class RegionalOrganizationFeeSharePdf < Prawn::Document
	def initialize(regional_organization,orchestras,person_members,view)
		super(top_margin: 70)
		@regional_organization = regional_organization
		@orchestras = orchestras
		@person_members = person_members
		@view = view
    @cur_year = Time.now.year

		font "Helvetica", :size => 10
		heading
		orchestra_list
		move_down(30)
		person_list	
	end

	def person_list
		text "Einzelmitglieder", :size=>24, :style=>:bold
  		table format_persons do 
			row(0).font_style = :bold
			columns(0).align = :right
#			columns(1..4).align = :left
  			self.row_colors = ["FFFFFF","DDDDDD"]
			self.header = true
			self.column_widths = { 0 =>50 }
		end
	end

	def format_persons
    @count=0
    @sum=0

    @result = Array.new
		@result <<[ "Mitgl.Nr.","Name" ]
    
    @result += @person_members.map do |item|
      @count+=1
      @sum+=item.lvPart
			[
        mglnr(item),
				item.fullname,
        @view.format_currency(item.lvPart,'EUR')
			]
		end

    @result << [ "","Summe",@view.format_currency(@sum,'EUR')]
	end

	def format_orchestras 
    @sum = 0
    @count= 0

    @result = Array.new

    @result << [ "Mglnr","Orchester","Mitglieder","Beitragsanteil" ] 


    @result += @orchestras.map do |item|
      if item.nil? next

      @count+=item.currentTotal unless item.currentTotal.nil?
      @sum+=item.currentLvShare unless item.currentLvShare.nil?
			[ mglnr(item),
				item.orchName,
				item.currentTotal,
				@view.format_currency(item.currentLvShare)
      ]
    end

    @result << [ "", "Summe",@count,@view.format_currency(@sum)] 

    @result
	end

	def orchestra_list
		text "Orchester", :size=>24,:style =>:bold
  		table format_orchestras do 
			row(0).font_style = :bold
			columns(0).align = :right
			columns(1).align = :left
			columns(2..3).align = :right
  			self.row_colors = ["FFFFFF","DDDDDD"]
			self.header = true
			self.column_widths = { 0 => 50, 2=>50,3=>50 }
		end
	end

  def mglnr(member) 
    str = member.mglnr.to_s

    if ( member.eintritt and member.eintritt.year == @cur_year) then
      str+=" (N)"
    elsif member.austritt_zum != nil then
      str+=" (A)"
    end
    str
  end

	def heading
		text "Landesverband #{@regional_organization.name}", :size => 30 , :style =>:bold
	end
	
end
