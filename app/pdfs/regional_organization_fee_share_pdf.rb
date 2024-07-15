require 'prawn'
class RegionalOrganizationFeeSharePdf < Prawn::Document
	def initialize(regional_organization,orchestras,person_members,view)
		super(top_margin: 70)
		@regional_organization = regional_organization
		@orchestras = orchestras
		@person_members = person_members
		@view = view
    @cur_year = Time.now.year

    font_dir = "/usr/share/fonts/truetype/liberation"
    font_families.update("LiberationSans" => {
      :normal => File.join(font_dir,"LiberationSans-Regular.ttf"),
      :italic => File.join(font_dir,"LiberationSans-Italic.ttf"),
      :bold => File.join(font_dir,"LiberationSans-Bold.ttf"),
      :bold_italic => File.join(font_dir,"LiberationSans-BoldItalic.ttf")
    })
    font "LiberationSans", :size => 10


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

      suffix = ""
      if not item.member.zero_member_fee_balance?
        suffix="nicht abgerechnet"
      end

      @sum+=item.lvPart
			[
        mglnr(item.member),
				item.fullname,
        @view.format_currency(item.lvPart,'EUR'),
        suffix
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
      if item.nil? then 
        next
      end

      rs = item.currentReportSheet
      lv_part = 0
      member_count = 0
 
      if not rs.nil? then 
        lv_part = rs.calcLvPart
        member_count = rs.calcGemaCount
      end

      @count+=member_count
      @sum+=lv_part 
      suffix = nil
      if not item.member.zero_member_fee_balance?
        suffix = " nicht abgrechnet"
      end
			[ mglnr(item.member),
				item.orchName,
				member_count,
				@view.format_currency(lv_part) ,
        suffix
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
