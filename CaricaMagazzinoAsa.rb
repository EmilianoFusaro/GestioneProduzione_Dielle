require 'rubygems'
require 'spreadsheet'
require "sequel"


DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=Simul;Data Source=10.0.2.8')   #---Office

class MagazzinoAsa < Sequel::Model(DB_3CAD[:magazzinoasa])
	set_primary_key [:codice]
end

puts "AGGIORNAMENTO MAGAZZINO ASA ATTENDERE .... \n \n"

begin
  #---Importa Il File Excel In Memoria
  #book = Spreadsheet.open('Magazzino.xls')  #Accedo al file xls indicato
  book = Spreadsheet.open('K:/XEmiliano/Import/magazzinoasa.xls')  #Accedo al file xls indicato
  sheet1 = book.worksheet('magazzinoasa')   #Accedo al foglio indicato
  primariga=true

  #---Svuota Completamente La Tabella
  MagazzinoAsa.dataset.destroy  

  sheet1.each do |row|
    
    break if row[0].nil?  # esco dal ciclo con la prima riga vuota

    r_magazzino=MagazzinoAsa.new
    r_magazzino.codice=row[0]
    r_magazzino.descrizione=row[1]
    r_magazzino.scarico=row[2]
    r_magazzino.save
    
  end

  #MagazzinoAsa.where(:codice=>"codice").destroy  #---elimino la prima riga di intestazione che non serve

  puts "AGGIORNAMENTO COMPLETATO !! ... PREMI INVIO PER CONTINUARE ..."
  gino=STDIN.gets.chomp()

rescue
  puts "ATTENZIONE ERRORE AGGIORNAMENTO NON COMPLETATO !!"
  puts "CHIUDERE IL FILE MAGAZZINO PRIMA DI AGGIORNARE !!"
  puts "... PREMI INVIO PER CONTINUARE ..."
  gino=STDIN.gets.chomp()
ensure


end



