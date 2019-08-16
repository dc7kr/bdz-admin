require 'prawn'
require 'prawn/table'
class RegionalOrganizationPdf < Prawn::Document
	def initialize(regional_organization,orchestras,person_members,year,view)
		super(top_margin: 70)
		@regional_organization = regional_organization
		@orchestras = orchestras
		@person_members = person_members
		@view = view
    if year.nil? then
      @year = Time.now.year
    else
      @year = year
    end

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
		[[ "Mitgl.Nr.","Name" ]]+
		@person_members.map do |item|
			[
        mglnr(item.member),
				item.address
			]
		end
	end

	def format_orchestras 
		[[ "Mglnr","Orchester","Gesamt","GEMA" ]] +
		@orchestras.map do |orch|
			[ mglnr(orch.member),
				orch.address+ ", "+
				orch.contact_info,
				orch.total(@year),
				orch.gema(@year),
        orch.age_key_str(@year)

    ]
		end
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

    if ( member.eintritt and member.eintritt.year == @year) then
      str+=" (N)"
    elsif member.austritt_zum != nil && member.austritt_zum.year != 0 then
      str+=" (A)"
    end
    str
  end

	def heading
		text "Landesverband #{@regional_organization.name}", :size => 30 , :style =>:bold
	end
	
end
