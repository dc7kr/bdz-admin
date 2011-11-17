script/rails generate scaffold UrlCategory parent:references, leaf:bool, hascountry:bool, description:string
script/rails generate scaffold Url category:references, url:string, titel:string, descr:string, sprache:string, land:references, bland:references email:string,user:references, lastchange:datatime, confirmed:datatime, ip:string,visible:bool
