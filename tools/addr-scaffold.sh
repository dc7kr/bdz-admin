script/rails g scaffold Address anrede:string,titel:string,vorname:string, name:string, strasse:string, plz:string, ort:string,telefon:string, mobil:string fax:string, email:string 
script/rails g scaffold Function label:string, lv:references, address:references, bund:bool, jugend:bool, nr:int, funktion:string, fktSubtitle:string

