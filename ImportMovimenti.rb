require 'csv'
require "sequel"

DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')
class Sgmes < Sequel::Model(DB_3CAD[:sgmes])
	set_primary_key [:codice]
end

class Sgdisp < Sequel::Model(DB_3CAD[:sgdisp])
	set_primary_key [:codice]
end

puts "AGGIORNAMENTO MOVIMENTI ATTENDERE .... \n \n"

Sgmes.dataset.destroy
Sgdisp.dataset.destroy

errori_sgmes =0
errori_sgdisp =0

percorso_file='//srv-gest/DSKPGM/ASA/TEXT/SGMES.csv'

#---corregge errori csv
text = File.open(percorso_file).read
text = text.gsub(/\r/," ") #rimuove i cr
text = text.gsub("\"","") #rimuove " 
File.write(percorso_file, text)  

#---Importa File Csv
conta=0
CSV.foreach(percorso_file , {:quote_char => "|" , :headers=> true}) do |row|    #headers: true salta la prima riga
  begin  	
    dati=row.to_s.split(";")
    r_sgmes=Sgmes.new
    r_sgmes.codice=dati[1]
    r_sgmes.descrizione=dati[2]
    r_sgmes.giacenzainiziale=dati[3].gsub(".","").to_f
    r_sgmes.gennaio=dati[5].gsub(".","").to_f-dati[6].gsub(".","").to_f
    r_sgmes.febbraio=dati[9].gsub(".","").to_f-dati[10].gsub(".","").to_f
    r_sgmes.marzo=dati[13].gsub(".","").to_f-dati[14].gsub(".","").to_f
    r_sgmes.aprile=dati[17].gsub(".","").to_f-dati[18].gsub(".","").to_f
    r_sgmes.maggio=dati[21].gsub(".","").to_f-dati[22].gsub(".","").to_f
    r_sgmes.giugno=dati[25].gsub(".","").to_f-dati[26].gsub(".","").to_f
    r_sgmes.luglio=dati[29].gsub(".","").to_f-dati[30].gsub(".","").to_f
    r_sgmes.agosto=dati[33].gsub(".","").to_f-dati[34].gsub(".","").to_f
    r_sgmes.settembre=dati[37].gsub(".","").to_f-dati[38].gsub(".","").to_f
    r_sgmes.ottobre=dati[41].gsub(".","").to_f-dati[42].gsub(".","").to_f
    r_sgmes.novembre=dati[45].gsub(".","").to_f-dati[46].gsub(".","").to_f
    r_sgmes.dicembre=dati[49].gsub(".","").to_f-dati[50].gsub(".","").to_f
    r_sgmes.save    
  rescue Exception => e 
    #puts e.message 
    errori_sgmes +=1
  ensure
  end
  
end

percorso_file='//srv-gest/DSKPGM/ASA/TEXT/SGDISP.csv'

#---corregge errori csv
text = File.open(percorso_file).read
text = text.gsub(/\r/," ")
text = text.gsub("\"","")
File.write(percorso_file, text)

#---Importa File Csv
CSV.foreach(percorso_file , {:quote_char => "|" , :headers=> true}) do |row| 
  begin
    dati=row.to_s.split(";")
    r_sgdisp=Sgdisp.new
    r_sgdisp.codice=dati[0]
    r_sgdisp.descrizione=dati[1]
    r_sgdisp.esistenza=dati[15].gsub(".","").to_f
    r_sgdisp.save          
  rescue Exception => e 
    #puts e.message 
    errori_sgdisp +=1
  ensure
  end
end



puts "AGGIORNAMENTO COMPLETATO !! SGMES ERRORI #{errori_sgmes}  SGDISP ERRORI #{errori_sgdisp} ... PREMI INVIO PER CONTINUARE ..."
#puts "AGGIORNAMENTO COMPLETATO !! ... PREMI INVIO PER CONTINUARE ..."
gino=STDIN.gets.chomp()




#------------Documentazione Utilizzata------------#
#---Classe Ruby CSV
#http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html
#---Sql Con Mese
#https://forum.openoffice.org/it/forum/viewtopic.php?f=13&t=544
#---Esempi import csv
#http://stackoverflow.com/questions/4410794/ruby-on-rails-import-data-from-a-csv-file
#http://stackoverflow.com/questions/4410794/ruby-on-rails-import-data-from-a-csv-file
#---Saltare la prima riga csv
#http://railscasts.com/episodes/396-importing-csv-and-excel?view=asciicast
#http://stackoverflow.com/questions/5936204/ignore-header-line-when-parsing-csv-file
#---Gestione Eccezioni
#http://rubylearning.com/satishtalim/ruby_exceptions.html
#---Correggere Illegal Quoting
#http://stackoverflow.com/questions/10594626/fix-invalid-csv-row-with-illegal-quoting-error-in-ruby-code
#http://stackoverflow.com/questions/9864064/csv-read-illegal-quoting-in-line-x
#---Guida all'importazione CSV
#http://www.sitepoint.com/guide-ruby-csv-library-part/
#http://www.sitepoint.com/guide-ruby-csv-library-part-2/
#---Operazioni Con I File & Stringhe
#http://stackoverflow.com/questions/287713/how-do-i-remove-carriage-returns-with-ruby
#http://stackoverflow.com/questions/287713/how-do-i-remove-carriage-returns-with-ruby
#http://stackoverflow.com/questions/1274605/ruby-search-file-text-for-a-pattern-and-replace-it-with-a-given-value
#http://stackoverflow.com/questions/2777802/how-to-write-to-file-in-ruby
#http://stackoverflow.com/questions/130948/ruby-convert-file-to-string
#http://stackoverflow.com/questions/4475957/how-to-read-an-open-file-in-ruby
#http://stackoverflow.com/questions/1274605/ruby-search-file-text-for-a-pattern-and-replace-it-with-a-given-value
#Librerie Sequel
#http://sequel.jeremyevans.net/rdoc/classes/Sequel/Database.html



