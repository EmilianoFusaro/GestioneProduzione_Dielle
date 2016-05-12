require "rubygems"
require "prawn"
#require 'barby'
#require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
require 'prawn-svg'
require 'fileutils'

$contastampa="001"

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="StampaPrelievi"

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"
load "K:/Ecadpro/RubyLogyUnion/CaricaModuloPrelievo.rb"

#-------------------------Elenco Variabili
#carico="0008"
carico=ARGV[0]

$colore_bindelle=Carico.colore_carico(carico)  #identifica il colore delle bindelle

#----Modifico Classe string per poter utilizzare espressione regolari su stringa intercettando i tag
class String  
  def to_rx
    Regexp.new( Regexp.quote(self), true )
  end
  def tag tg
    return nil  unless self =~ ("<#{tg}>".to_rx)
    return nil  unless   $' =~ ("</#{tg}>".to_rx)
    $`
  end
end

def genera_prelievo(carico,reparto,fase,tipostampa,nomestampa)

  #puts "#{reparto}-#{fase}-#{tipostampa}-#{nomestampa}"
  stampa=TipoStampa.where(:codice=>tipostampa).all  
  #puts stampa[0].percorsofile

  #if tipostampa==106 or tipostampa==1 or tipostampa==2 or tipostampa==108 or tipostampa==105 or tipostampa==105  #tipostampa è un intero
  #tipostampa==101 (non esistino)
  #tipostampa==102 (non esistino)
  #tipostampa==103 (non esistino reparti con 103 associata)
  #tipostampa==104 (non stampa niemte)
  #tipostampa==107 (non esistino reparti con 107 associata)
  #tipostampa==115 è il vecchio 108 usato per i nuovi cassetti

  if tipostampa==106 or tipostampa==1 or tipostampa==2 or tipostampa==108 or tipostampa==105 or tipostampa==109 or tipostampa==110 or tipostampa==111 or tipostampa==112 or tipostampa==113 or tipostampa==114 or tipostampa==115  #tipostampa è un intero

     string = IO.read("K:/Ecadpro/RubyLogyUnion/ModuliStampa/#{stampa[0].percorsofile}") #apre il file mette in una stringa

     sql=string.tag("sql")
     testa=string.tag("testa")
     rigarecord=string.tag("record")  
     rigarecordgrande=string.tag("recordgrande")  #record aggiunto per gestire descrizioni lunghe  
     sql=eval(sql)
  
     pdf = Prawn::Document.new(:page_size => 'A4',:page_layout => :landscape,:margin => [1])
     pdf.font_size 8 
     pdf.fill_color "#{$colore_bindelle}"
     #posizone x posizione y (600 e dall'alto),dimensone x,dimensone y
     pdf.fill_rectangle [-1, 600], 845, 600
     pdf.fill_color '000000'  #pennello nero

     prima_pagina=true
     #Con Le Nuove Stampe Devo Valutare la testa nella prima riga
     #testa.split("\n").each{ |rigatesta|   
     #   eval(TraduciComandi(rigatesta,0))
     #} 
  
     sposta_record=0
     appo_destinazione=""
     spazio_riga=10
     if stampa[0].margine_cod==1
       primo_limite=61-9 #differezio descrizione insieme al codice (solo alcune stampe)
     else
       primo_limite=61
     end 

     #Attenzione Da Fare x Giuseppe Gestire La Possibilità di Didere il tabulato per un parametro specifico esempio x montato & smontato (TempSlip.flag )ù
     #File.open("TEST.txt", 'a') { |file| file.write(sql) }  
     presenza_dati=false  #se non ho dati non salvo il pdf
     DB_ECAD.fetch(sql) do |rigax|
       #puts sql
       #puts "#{rigax[:rdestinazione]} <-> #{appo_destinazione}"
       #File.open("c:/gino.txt", 'a') { |file| file.write(sql_prelievi ) }
       #gino=STDIN.gets.chomp()

       if prima_pagina==true
         #Con Le Nuove Stampe Devo Valutare la testa nella prima riga
         testa.split("\n").each{ |rigatesta|   
         eval(TraduciComandi(rigatesta,0))
         prima_pagina=false
         presenza_dati=true
         }
       end   

       if ((rigax[:drdestinazione] != appo_destinazione) and (sposta_record>0)) or (sposta_record==170)
           pdf.start_new_page
           pdf.fill_color "#{$colore_bindelle}"
           #posizone x posizione y (600 e dall'alto),dimensone x,dimensone y
           pdf.fill_rectangle [-1, 600], 845, 600
           pdf.fill_color '000000'  #pennello nero
           testa.split("\n").each{ |rigatesta|                 
              eval(TraduciComandi(rigatesta,0))
              sposta_record=0
              conta=1
              } 
       end
       
       if (rigax[:descrizione].size>primo_limite) or (rigax[:pdes].size>61)
         rigarecordgrande.split("\n").each{ |rigay|         
          eval(TraduciComandi(rigay,sposta_record))      
         } 
         spazio_riga=20
       else
         rigarecord.split("\n").each{ |rigay|         
          eval(TraduciComandi(rigay,sposta_record))      
         }
         spazio_riga=10
       end  

     sposta_record=sposta_record+spazio_riga
     appo_destinazione=rigax[:drdestinazione]

     end

     if carico.include? "C"
       cartella_dest="LACCATI"
     else    
       cartella_dest="CARICHI"
     end
     
     if presenza_dati==true  #stampo solo in presenza di dati (gestione stampe laccate speciali x walter)
       pdf.render_file "K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}/#{$contastampa}_#{nomestampa.gsub("<", "_").gsub("  ", "").gsub("/", "-").gsub(":", " ")}.pdf"
       puts "Stampa :#{$contastampa}_#{nomestampa.gsub("<", "_")} Ok"
     else
       puts "Non Ci Sono Dati X Stampa :#{$contastampa}_#{nomestampa.gsub("<", "_")} Ok"
     end  

     $contastampa=$contastampa.next

   end
end

#---------------------------------------------------------------------------------------------MAIN()
if carico.include? "C"
    sql_tipocarico=" And TempSlip.Islaccato=1 "
    $laccato=1
    cartella_dest="LACCATI"
else    
    sql_tipocarico=" And TempSlip.Islaccato=0 "
    $laccato=0
    cartella_dest="CARICHI"
end    

#--------------------------Query Generale Che Esplode la Lista Dei File
sql_prelievi="SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C1 as ciclo , 'C1' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.C1 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}" 
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C2 as ciclo ,'C2' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.C2 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}"
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C3 as ciclo ,'C3' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.C3 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}"
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C4 as ciclo , 'C4' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.C4 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}"
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT    DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C5 as ciclo ,'C5' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.C5 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}"
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C6 as ciclo ,'C6' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.c6 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}"  
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C7 as ciclo , 'C7' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.c7 "
sql_prelievi=sql_prelievi + " WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico}"
sql_prelievi=sql_prelievi + "UNION "
sql_prelievi=sql_prelievi + "SELECT DISTINCT OrdineStampa.Ordinatore, OrdineStampa.Reparto, Reparti.Descrizione, Reparti.TipoStampa, Reparti.Classe, TempSlip.C8 as ciclo  ,'C8' as fase "
sql_prelievi=sql_prelievi + "FROM OrdineStampa INNER JOIN Reparti ON OrdineStampa.Reparto = Reparti.Codice INNER JOIN TempSlip ON Reparti.Codice = TempSlip.c8 "
sql_prelievi=sql_prelievi + "WHERE TempSlip.carico='#{carico}' #{$filtroordini} #{sql_tipocarico} ORDER BY Ordinatore "

#File.open("c:/gino.txt", 'w') { |file| file.write(sql_prelievi ) }

#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}")
end


#-------------------------------------------------------------------------------------------------------------------PRELIEVI STANDARD
DB_ECAD.fetch(sql_prelievi) do |riga|

  case riga[:classe]
  when 4,11,13          #Attenzione Sto Escludendo Le Classi
     genera_prelievo(carico,riga[:reparto],riga[:fase],riga[:tipostampa],riga[:descrizione])
  end	

end

unless carico.include? "C" 
  puts "------------------------------------------------------------------------Stampe Speciali X Walter:"
  genera_prelievo(carico,"1503","drdestinazione",111,"PREL ANTE LACCATE")
  genera_prelievo(carico,"1580","drdestinazione",112,"PREL CASSETTI LACCATI")
  puts "------------------------------------------------------------------------"
end

