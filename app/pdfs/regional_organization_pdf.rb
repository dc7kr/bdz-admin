require 'prawn'
class RegionalOrganizationPdf < Prawn::Document
	def initialize(regional_organization,orchestras,person_members,view)
		super(top_margin: 70)
		@regional_organization = regional_organization
		@orchestras = orchestras
		@person_members = person_members
		@view = view

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
		[[ "Mitgl.Nr.","Name" ]]+
		@person_members.map do |item|
			[
				item.mglnr,
				item.address
			]
		end
	end

	def format_orchestras 
		[[ "Mglnr","Orchester","Gesamt","GEMA" ]] +
		@orchestras.map do |item|
			[ item.mglnr,
				item.address+ ", "+
				(item.telefon ? item.telefon : "") +", "+
				(item.email ? item.email : ""),
				item.currentTotal,
				item.currentGema ]
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

	def heading
		text "Landesverband #{@regional_organization.name}", :size => 30 , :style =>:bold
	end
	
end
