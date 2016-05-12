require 'spreadsheet'
load "K:/Ecadpro/RubyLogyUnion/connessione.rb"

puts "AGGIORNAMENTO MATERIALE DI RECUPERO ATTENDERE .... \n \n"

begin
  #----------------------------------------------------Svuota Tabelle Recuper Articoli & Distinta Ecad & 3Cad
  sql ="update distinta set dimensioni='' where codfig in (select cod from articoli where [var] like '%REC;%')"
  update_ds = DB_ECAD[sql]
  update_ds.update
  
  sql ="update articoli set [var]='' where  [var] like '%REC%'"
  update_ds = DB_ECAD[sql]
  update_ds.update

  sql ="update [distinta] set dimensioni='' where codfig in (select cod from articoli where [var] like '%REC;%')"
  update_ds = DB_3CAD[sql]
  update_ds.update
  
  sql ="update [articoli] set [var]='' where  [var] like '%REC%'"
  update_ds = DB_3CAD[sql]
  update_ds.update

  #---Importa Il File Excel In Memoria
  book = Spreadsheet.open('K:/XEmiliano/ECAD-MODUS/Lista_Semilavorati_da_Recupero.xls')  #Accedo al file xls indicato  

  sheet1 = book.worksheet('codici')   #Accedo al foglio indicato
  primariga=true

  #---Svuota Completamente La Tabella
  MaterialeRecupero.dataset.destroy
 
  sheet1.each do |row|    
    break if row[0].nil?  # esco dal ciclo con la prima riga vuota
    r_MaterialeRecupero=MaterialeRecupero.new
    r_MaterialeRecupero.codice=row[0]
    r_MaterialeRecupero.descrizione=''
    r_MaterialeRecupero.selco=            if row[1]=="X" then true else false end
    r_MaterialeRecupero.magazzino=        if row[2]=="X" then true else false end
    #if row[3]!=nil
    #  r_MaterialeRecupero.correggix=row[3].to_f
    #end
    r_MaterialeRecupero.correggix=        if row[3]!=nil then row[3].to_f else 0 end
    r_MaterialeRecupero.correggiy=        if row[4]!=nil then row[4].to_f else 0 end
    r_MaterialeRecupero.correggiz=        if row[5]!=nil then row[5].to_f else 0 end
    r_MaterialeRecupero.save
  end

  MaterialeRecupero.where(:codice=>"codice").destroy  #---elimino la prima riga di intestazione che non serve

  #----------------------------------------------------Aggiorna Articoli & Distinta Ecad & 3Cad
  sql ="Update Articoli Set [var]='REC;' Where Cod In (select Codice from MaterialeRecupero where selco=1)"
  update_ds = DB_ECAD[sql]
  update_ds.update

  sql ="Update Distinta Set Dimensioni=';;;;;;;;;REC=*:REC=001' Where Codfig In (select Codice from MaterialeRecupero where selco=1)"
  update_ds = DB_ECAD[sql]
  update_ds.update

  sql ="Update [Articoli] Set [var]='REC;' Where Cod In (select Codice from MaterialeRecupero where selco=1)"
  update_ds = DB_3CAD[sql]
  update_ds.update
 
  sql ="Update [Distinta] Set Dimensioni=';;;;;;;;;REC=*:REC=001' Where Codfig In (select Codice from MaterialeRecupero where selco=1)"
  update_ds = DB_3CAD[sql]
  update_ds.update

  puts "AGGIORNAMENTO COMPLETATO !! ... PREMI INVIO PER CONTINUARE ..."
  gino=STDIN.gets.chomp()

rescue
  puts "ATTENZIONE ERRORE AGGIORNAMENTO NON COMPLETATO !!"
  puts "CHIUDERE IL FILE LISTA SEMILAVORATI DA RECUPERO PRIMA DI AGGIORNARE !!"
  puts "... PREMI INVIO PER CONTINUARE ..."
  gino=STDIN.gets.chomp()
ensure

end




