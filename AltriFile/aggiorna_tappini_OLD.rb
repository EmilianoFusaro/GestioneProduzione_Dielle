#----Procedura Creata 06.07.2015 Emiliano
#----Aggiorna la distinta di 3cad e ecad inserendo i tappini
#----Importa i dati dal file excel in k:\EcadPro\RubyLogyUnion\AltriFile


require 'rubygems'
require 'spreadsheet'
require "sequel"

DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')  #---Connessione DB Ecad
DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                #---Connessione DB 3cad


class Distinta3cad < Sequel::Model(DB_3CAD[:distinta]) #---Mappa Distinta 3cad
	set_primary_key [:cod,:prog]
end


class DistintaEcad < Sequel::Model(DB_ECAD[:distinta]) #---Mappa Distinta Ecad
	set_primary_key [:cod,:prog]
end


#---Svuota le distinte da i tappini
Distinta3cad.where("prog = ? or prog = ?", 500,501).delete  #---Svuota Distinta 3cad
DistintaEcad.where("prog = ? or prog = ?", 500,501).delete  #---Svuota Distinta Ecad

book = Spreadsheet.open('K:/EcadPro/RubyLogyUnion/AltriFile/ListaTappini.xls')  #Accedo al file xls indicato  
sheet1 = book.worksheet('LISTA')   #Accedo al foglio indicato

begin

  sheet1.each do |row|    
    break if row[0].nil?  # esco dal ciclo con la prima riga vuota
		
	unless row[1].include? ";"	       #-----Ho solo un figlio da inserire
	 
	  r_dist3cad=Distinta3cad.new
	  r_dist3cad.cod=row[0]
	  r_dist3cad.prog=500
	  r_dist3cad.codfig=row[1]
	  r_dist3cad.qta=row[2]
	  r_dist3cad.valido=row[3]
	  r_dist3cad.dimensioni=row[4]
	  r_dist3cad.save
	
	  r_distEcad=DistintaEcad.new
	  r_distEcad.cod=row[0]
	  r_distEcad.prog=500
	  r_distEcad.codfig=row[1]
	  r_distEcad.qta=row[2]
	  r_distEcad.valido=row[3]
	  r_distEcad.dimensioni=row[4]
	  r_distEcad.save

    else                              #-----Ho più figli da inserire
      
	  count=0
      riga=row[1].split(";")
      riga.each{ |i|	  
	    
		r_dist3cad=Distinta3cad.new
	    r_dist3cad.cod=row[0]
	    r_dist3cad.prog=500+count
	    r_dist3cad.codfig=i
		
		r_distEcad=DistintaEcad.new
	    r_distEcad.cod=row[0]
	    r_distEcad.prog=500+count
	    r_distEcad.codfig=i
		
		if row[2].include? ";"
		  r_dist3cad.qta=row[2].split(";")[count]
		  r_distEcad.qta=row[2].split(";")[count]
		else
		  r_dist3cad.qta=row[2]
		  r_distEcad.qta=row[2]
		end
	    
		if row[3].include? ";"
		  r_dist3cad.valido=row[3].split(";")[count]
		  r_distEcad.valido=row[3].split(";")[count]
		else
		  r_dist3cad.valido=row[3]
		  r_distEcad.valido=row[3]
		end
	    
		if row[4].include? ";"
	      r_dist3cad.dimensioni=row[4].split(";")[count]
		  r_distEcad.dimensioni=row[4].split(";")[count]
		else
	      r_dist3cad.dimensioni=row[4]
		  r_distEcad.dimensioni=row[4]
		end
		
		count=count+1
	    r_dist3cad.save
		r_distEcad.save
		
      }	
	  
    end
	
  end
 
rescue Exception => e 
  #puts "ATTENZIONE ERRORE INSERIMENTO NON COMPLETATO !!  CODICE #{sentinella}"
  puts "ATTENZIONE ERRORE INSERIMENTO NON COMPLETATO !!  CODICE"
  puts e.message  
  puts e.backtrace.inspect  
  #gino=STDIN.gets.chomp()  #questa istruzione genera un errore
ensure

end
