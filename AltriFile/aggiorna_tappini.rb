#----Procedura Creata 06.07.2015 Emiliano
#----Aggiorna la distinta di 3cad e ecad inserendo i tappini
#----Importa i dati dal file excel in k:\EcadPro\RubyLogyUnion\AltriFile


require 'rubygems'
require 'spreadsheet'
require "sequel"
Encoding.default_external = 'UTF-8'

DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')  #---Connessione DB Ecad
DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                #---Connessione DB 3cad


class Distinta3cad < Sequel::Model(DB_3CAD[:distinta]) #---Mappa Distinta 3cad
	set_primary_key [:cod,:prog]
end


class Lista_Tappini < Sequel::Model(DB_3CAD[:lista_tappini]) #---Mappa Lista_Tappini 3cad
	set_primary_key [:cod]
end


class DistintaEcad < Sequel::Model(DB_ECAD[:distinta]) #---Mappa Distinta Ecad
	set_primary_key [:cod,:prog]
end


#---Svuota le distinte da i tappini
Distinta3cad.where("prog = ? or prog = ?", 500,501).delete  #---Svuota Distinta 3cad
DistintaEcad.where("prog = ? or prog = ?", 500,501).delete  #---Svuota Distinta Ecad


lista_tappini=Lista_Tappini.all


begin

lista_tappini.each{ |riga|  
  
  unless riga.codfig.include? "@"	       #-----Ho solo un figlio da inserire
  
    r_dist3cad=Distinta3cad.new
    r_dist3cad.cod=riga.cod
	r_dist3cad.prog=500
	r_dist3cad.codfig=riga.codfig
	r_dist3cad.qta=riga.qta
	r_dist3cad.valido=riga.valido
	r_dist3cad.dimensioni=riga.dimensioni
	r_dist3cad.save
	
	r_distEcad=DistintaEcad.new
	r_distEcad.cod=riga.cod
	r_distEcad.prog=500
	r_distEcad.codfig=riga.codfig
	r_distEcad.qta=riga.qta.gsub(",",".")
	r_distEcad.valido=riga.valido
	r_distEcad.dimensioni=riga.dimensioni
	r_distEcad.save

  else                              #-----Ho più figli da inserire
      
	  count=0
      row=riga.codfig.split("@")
      row.each{ |i|	  
	    
		r_dist3cad=Distinta3cad.new
	    r_dist3cad.cod=riga.cod
	    r_dist3cad.prog=500+count
	    r_dist3cad.codfig=i
		
		r_distEcad=DistintaEcad.new
	    r_distEcad.cod=riga.cod
	    r_distEcad.prog=500+count
	    r_distEcad.codfig=i
		
		if riga.qta.include? "@"
		  r_dist3cad.qta=riga.qta.split("@")[count]
		  r_distEcad.qta=riga.qta.split("@")[count].gsub(",",".")
		else
		  r_dist3cad.qta=riga.qta
		  r_distEcad.qta=riga.qta.gsub(",",".")
		end
	    
		if riga.valido.include? "@"
		  r_dist3cad.valido=riga.valido.split("@")[count]
		  r_distEcad.valido=riga.valido.split("@")[count]
		else
		  r_dist3cad.valido=riga.valido
		  r_distEcad.valido=riga.valido
		end
	    
		if riga.dimensioni.include? "@"
	      r_dist3cad.dimensioni=riga.dimensioni.split("@")[count]
		  r_distEcad.dimensioni=riga.dimensioni.split("@")[count]
		else
	      r_dist3cad.dimensioni=riga.dimensioni
		  r_distEcad.dimensioni=riga.dimensioni
		end
		
		count=count+1
	    r_dist3cad.save
		r_distEcad.save
		
      }	
	  
  end
  
}

rescue Exception => e 
  #puts "ATTENZIONE ERRORE INSERIMENTO NON COMPLETATO !!  CODICE #{sentinella}"
  puts "ATTENZIONE ERRORE INSERIMENTO NON COMPLETATO !!  CODICE"
  puts e.message  
  puts e.backtrace.inspect  
  #gino=STDIN.gets.chomp()  #questa istruzione genera un errore
ensure

end
