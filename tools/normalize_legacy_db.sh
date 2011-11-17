INSERT INTO report_sheets (id,year,orchestra_id, children,teens, youth,adult,zeitungen,gema,uv,passive,azubi) SELECT NULL , 2011 , id , numBis14, num15bis18 , num19bis27 , numUeber27 , zeitungen, gema, unfallversicherung , passive, azubi FROM orchestras

