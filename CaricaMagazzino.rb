#require 'rubygems'
require 'spreadsheet'
load "K:/Ecadpro/RubyLogyUnion/connessione.rb"

puts "AGGIORNAMENTO MAGAZZINO ATTENDERE .... \n \n"

begin
  #---Importa Il File Excel In Memoria
  #book = Spreadsheet.open('Magazzino.xls')  #Accedo al file xls indicato 
  book = Spreadsheet.open('K:/XEmiliano/ECAD-MODUS/Magazzino.xls')  #Accedo al file xls indicato  
  sheet1 = book.worksheet('SEMILAVORATI')   #Accedo al foglio indicato
  primariga=true

  #---Svuota Completamente La Tabella
  Magazzino.dataset.destroy  
  
  #errore_codice=""

  sheet1.each do |row|
    
    break if row[0].nil?  # esco dal ciclo con la prima riga vuota
    #puts row[0]
    r_magazzino=Magazzino.new
    r_magazzino.codice=row[0]
    r_magazzino.descrizione=row[1]
    r_magazzino.dimx=row[2].to_f
    r_magazzino.dimy=row[3].to_f
    r_magazzino.dimz=row[4].to_f
    r_magazzino.tipologia=""            #---Tipologia Da Definire
    r_magazzino.bianco=           if row[5]=="X" then true else false end
    r_magazzino.larice=           if row[6]=="X" then true else false end
    r_magazzino.roverenaturale=   if row[7]=="X" then true else false end
    r_magazzino.corda=            if row[8]=="X" then true else false end
    r_magazzino.roveretabacco=    if row[9]=="X" then true else false end
    r_magazzino.olmoperla=        if row[10]=="X" then true else false end
    r_magazzino.olmonaturale=     if row[11]=="X" then true else false end
    r_magazzino.olmolava=         if row[12]=="X" then true else false end
    r_magazzino.mandarino=        if row[13]=="X" then true else false end
    r_magazzino.girasole=         if row[14]=="X" then true else false end
    r_magazzino.magnolia=         if row[15]=="X" then true else false end
    r_magazzino.alabastro=        if row[16]=="X" then true else false end
    r_magazzino.avio=             if row[17]=="X" then true else false end
    r_magazzino.verdeprimavera=   if row[18]=="X" then true else false end
    r_magazzino.glicine=          if row[19]=="X" then true else false end
    r_magazzino.acero=            if row[20]=="X" then true else false end
    r_magazzino.punto=            if row[21]=="X" then true else false end
    r_magazzino.riga=             if row[22]=="X" then true else false end
    r_magazzino.acxbianco=        if row[23]=="X" then true else false end
    r_magazzino.acxtortora=       if row[24]=="X" then true else false end
    r_magazzino.moro=             if row[25]=="X" then true else false end
    r_magazzino.olmocenere=       if row[26]=="X" then true else false end
    r_magazzino.famiglia=row[27]
    r_magazzino.save
    #errore_codice=row[0]
  end

  Magazzino.where(:codice=>"codice").destroy  #---elimino la prima riga di intestazione che non serve

  puts "AGGIORNAMENTO COMPLETATO !! ... PREMI INVIO PER CONTINUARE ..."
  gino=STDIN.gets.chomp()

rescue
  #puts "ATTENZIONE ERRORE AGGIORNAMENTO NON COMPLETATO !! #{errore_codice}"
  puts "ATTENZIONE ERRORE AGGIORNAMENTO NON COMPLETATO !!"
  puts "CHIUDERE IL FILE MAGAZZINO PRIMA DI AGGIORNARE !!"
  puts "... PREMI INVIO PER CONTINUARE ..."
  gino=STDIN.gets.chomp()
ensure


end

#Errori Riscontrati
#Attenzione Se Manca La Famiglia Va In Errore


