#Script che recupera le dimensioni delle macro dalla tabella Macrot  (Clone Di Macro)
require "sequel"

DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                 #---Office

class Macrot < Sequel::Model(DB_3CAD[:macrot])
	set_primary_key [:cat, :cod]
end

tab_macrot=Macrot.all

tab_macrot.each do |rmacro|
     p1=rmacro.macro.split("[BOX]")
     if p1[1]!=nil
     	p2=p1[1].split(",")
     	if p2[2]!=nil
     		rmacro.gruppo=p2[2]
     	else
     		rmacro.gruppo=""
     	end
     	if p2[3]!=nil
     		rmacro.gruppo2=p2[3]
     	else
     		rmacro.gruppo2=""
     	end
     	if p2[4]!=nil
     		rmacro.gruppo3=p2[4]
     	else
     		rmacro.gruppo3=""
     	end
     else
     	rmacro.gruppo=""
     	rmacro.gruppo2=""
     	rmacro.gruppo3=""
     end
     rmacro.save
end





