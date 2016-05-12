require "rubygems"
require "rubygems"
require 'fileutils'

Encoding.default_external = 'UTF-8'

$nome_file="ElaboraCarico"
#$esito=true

#$nome_file=__FILE__     #specifica nella connessione il file chiamante forse anche $0
#$nome_file=__FILE__     #specifica nella connessione il file chiamante forse anche $0

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"
load "K:/Ecadpro/RubyLogyUnion/elaboraslipXX.rb"
load "K:/Ecadpro/RubyLogyUnion/funzioni_caricoX.rb"
load "K:/Ecadpro/RubyLogyUnion/funzioni_caricoX_Lacc.rb"
load "K:/Ecadpro/RubyLogyUnion/ClassiRuby.rb"

#-------------------------Elenco Variabili

#ARGV.each do|a|
#  puts "Argument: #{a}"
#end
#puts ARGV[0]
#Carico="7001"

carico=ARGV[0]
filtroordini=ARGV[1]


slip=Slip.new
slipunion=SlipUnion.new

varianti_tradurre=""

$lista_reparti=Reparti.all
$lista_varianti=Varianti.all
lista_cicli=Cicli.all
lista_magazzino=Magazzino.all

puts "Inizio Elaborazione Carico #{carico}"

#-------------------------Svuoto Carico Precedente
tempslip=TempSlip.where(:carico=>carico)
tempslip.destroy

#-------------------------Filtra Solo Alcuni Ordini
if filtroordini == nil
  $filtroordini=""
else
  $filtroordini="And Numero in " + "(" + filtroordini.gsub(/\D/,",") + ") "
end

#sql="SELECT * From RubyComponentix Where (Carico='#{carico}' Or Commessa='#{carico}') #{$filtroordini} And TipoRiga=3"
if carico.include? "C"  
  sql="SELECT * From RubyComponentix Where Commessa='#{carico}' #{$filtroordini} And (TipoRiga='3' or TipoRiga='5' or (TipoRiga='1' and Codart In('016600000','016602000','016600001','016602001')))"
  cartella_dest="LACCATI"
  conta_slip=1

  DB_3CAD.fetch(sql) do |riga|
    unless riga[:famiglie].nil?    #se non è nullo effettuo controllo magazzino
      ciclo_magazzino=TrovaMagazzinoXLacc(riga,lista_magazzino)
      
      unless ciclo_magazzino.nil?        
        slipunion.DatiCarico(ciclo_magazzino,conta_slip,carico)
        conta_slip=conta_slip+1
      else
        #puts "Attenzione Salto La Riga Non Laccata #{riga}"
      end
      
    else
      sqllogy="SELECT * From Logy_Componenti Where Carico='#{carico}' #{$filtroordini} And Len(Ciclo)>=4 and riga='#{riga[:riga]}' and numero='#{riga[:numero]}'"  #(limit 20)

      DB_3CAD.fetch(sqllogy) do |rigalogy|

        islaccato=false
        variante=rigalogy[:pvarianti].split(";")

        variante.each{ |i|
        if ($stringa_laccati.include? i) and (i.size>=6)   #verificare se necessario i.size>=6
          islaccato=true
          break
        end
        }

        if islaccato==true    #Se Ciclo Non è laccato salto ttto    
          ciclo=TrovaCicloX(rigalogy[:ciclo],rigalogy[:pcod],rigalogy[:pcodbarra],rigalogy[:varianti],islaccato,lista_cicli)
          unless ciclo==false
            slip.DatiCarico(rigalogy,ciclo,islaccato,conta_slip)
            conta_slip =conta_slip+1
          end
        end 

      end
    end
    
  end  

else
  #sql="SELECT * From RubyComponentix Where Carico='#{carico}' #{$filtroordini} And TipoRiga='3'"
  sql="SELECT * From RubyComponentix Where Carico='#{carico}' #{$filtroordini} And (TipoRiga='3' or TipoRiga='5' or (TipoRiga='1' and Codart In('016600000','016602000','016600001','016602001')))"
  cartella_dest="CARICHI"
  conta_slip=1
  DB_3CAD.fetch(sql) do |riga|
    unless riga[:famiglie].nil?    #se non � nullo effettuo controllo magazzino
      ciclo_magazzino=TrovaMagazzinoX(riga,lista_magazzino)
      unless ciclo_magazzino.nil?
        slipunion.DatiCarico(ciclo_magazzino,conta_slip,carico)
        conta_slip=conta_slip+1
        #puts "ciclo trovato"         #x debug
      else
         puts "Attenzione Errore Nella Ricerca Magazzino #{riga[:codice]}"
      end
    else
      #:TODO gestire elementi non trovati
      #puts "Ciclo #{riga[:cod]} Non Trovato Elaborazione Classica" #x debug
      sqllogy="SELECT * From Logy_Componenti Where Carico='#{carico}' #{$filtroordini} And Len(Ciclo)>=4 and riga='#{riga[:riga]}' and numero='#{riga[:numero]}'"  #(limit 20)

      #File.open("TEST.txt", 'a') { |file| file.write("#{sqllogy}\n") }  #appende in un file di testo  x TEST

      DB_3CAD.fetch(sqllogy) do |rigalogy|

        islaccato=false
        variante=rigalogy[:pvarianti].split(";")

        #File.open("TEST.txt", 'a') { |file| file.write("#{rigalogy}\n") }  #appende in un file di testo  x TEST

        variante.each{ |i|
        #if $stringa_laccati.include? i
        if ($stringa_laccati.include? i) and (i.size>=6)   #verificare se necessario i.size>=6
          #puts "Trovato Laccato #{rigalogy[:pcod]}-#{rigalogy[:pdes]}"
          islaccato=true
          break
        end
        }

        #per controllare se passa un codice
        #if rigalogy[:pcod]=="056026241"
        #   puts "trovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovatotrovato"
        #   puts rigalogy
        #   File.open("gino.txt", 'w') { |file| file.write(rigalogy) }
        #end

        ciclo=TrovaCicloX(rigalogy[:ciclo],rigalogy[:pcod],rigalogy[:pcodbarra],rigalogy[:varianti],islaccato,lista_cicli)

        #if rigalogy[:pcod]=="052132331"
        #  File.open("TEST.txt", 'a') { |file| file.write("#{ciclo}\n") }  #appende in un file di testo  x TEST
        #end

        #puts "#{rigalogy[:ciclo]},#{rigalogy[:pcod]},#{rigalogy[:pcodbarra]},#{rigalogy[:varianti]},#{islaccato}" #x debug

        #Controllo Filtro e cilo ereditato
        #puts "#{rigalogy[:pcod]}   #{ciclo}"

        unless ciclo==false
          slip.DatiCarico(rigalogy,ciclo,islaccato,conta_slip)
          conta_slip =conta_slip+1
          # puts "ciclo trovato"         #x debug
          # else                           #x debug
          # puts "ciclo non trovato"     #x debug
         end
      end
    end
    #unless ciclo==false
    #  slip.DatiCarico(rigalogy,ciclo,islaccato)
    #end
  end

end

puts "Elaborazione Carico #{carico} OK"


system("ruby K:/Ecadpro/RubyLogyUnion/StampaSlipXX.rb '#{carico}'")          #Elaborazione & Stampa Slip
#puts $esito
#if $esito==false
#   exit
#end


puts "Elaborazione Slip OK"

  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraPrelieviXX.rb '#{carico}'")     #Elaborazione & Stama Prelievi

  unless carico.include? "C"
    if CaricoComp.presenza_inserti(carico)==true
      system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraInsertiLaguna.rb '#{carico}'")   #Elaborazione Prelievo Manigie Laguna Laccati + Normali Insieme
    end
  end 

  unless carico.include? "C"
    if CaricoComp.presenza_tappini_laccati(carico)==true 
      system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraPrelievoTappiniLaccati.rb '#{carico}'")        #Elaborazione Prelievo Tappini Solo Laccato
    end  
  end
  
puts "Elaborazione Prelievi OK"

if carico.include? "C"   #Se Ho Un Carico Laccato Includo Moduli Di Stampa Aggiuntivi

  #---Stampa Deprecata
  #system("ruby K:/Ecadpro/RubyLogy/ElaboraLaccatiXX.rb '#{carico}'")     #Elaborazione & Stampa Laccati

  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraLaccatiXOrdine.rb '#{carico}'")             #Elaborazione & Stampa Laccati X Ordine
  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraLaccatiXVariante.rb '#{carico}'")           #Elaborazione & Stampa Laccati X Ordine
  #verificare se va in tega
  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraSlipMancantiLaccati.rb '#{carico}'")        #Elaborazione & Stampa Slip Con Codici Padri Che Non Hanno Ciclo Ma Sono Da Laccare  
  #Wolf 16.09.15 la vuole solo sui Carichi Normali
  #if CaricoComp.presenza_tappini_laccati(carico)==true 
  #  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraPrelievoTappiniLaccati.rb '#{carico}'")        #Elaborazione Prelievo Tappini Solo Laccato
  #end

  #begin
  if ENV["COMPUTERNAME"]=="DL020"
    system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraLaccatiXExcel.rb '#{carico}'")              #Elaborazione File Excel x Cremasco
  else
     puts "Non Ho Eseguito Elaborazione Excel X Laccati Wolf"
  end
  #rescue => detail
  #  #print detail.backtrace.join("\n")
  #  echo "Non Ho Eseguito Elaborazione Laccati"
  #end
  
  #-------------------------------------------------------Creazione File Di Testo Carico  

if ENV["COMPUTERNAME"]!="DL019"
#-------------------------------------------------------Invio Mail Francesco
require 'net/smtp'
message = <<EOF
From: Elaborazione Carico Laccato<fusaro@dielle.it>
To: RECEIVER <fedato@dielle.it>
Subject: Elaborazione Carico Laccato
Elaborato Carico Laccato #{carico}.
EOF

smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls
smtp.start('gmail.com', 'fusaro@dielle.it', 'sole33', :login)
smtp.send_message message, 'fusaro@dielle.it', 'fedato@dielle.it' , 'collet@dielle.it' , 'cremasco@dielle.it' , 'facchin@dielle.it'
smtp.finish
else
  puts "---------------NON INVIO EMAIL---------------"
end

else

  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraSlipMancantiNormali.rb '#{carico}'")        #Elaborazione & Stampa Slip Con Codici Padri Che Non Hanno Ciclo

end


#sleep 1
#gino.gets  questo da errone


#----------------------------------------------------Aggiunge Date Carico
sql ="Update TempSlip Set DataListaInvio=ListaCarichi_ASA.DataListaInvio,DataPartenza=ListaCarichi_ASA.DataPartenza,DataCaricoCamion=ListaCarichi_ASA.DataCaricoCamion "
sql +=" From TempSlip INNER JOIN ListaCarichi_ASA ON TempSlip.Numero = ListaCarichi_ASA.NumeroOrdine "
sql +="Where TempSlip.Carico='#{carico}' "
update_ds = DB_ECAD[sql]
update_ds.update


#----------------------------------------------------Aggiunge Date Elaborazione (aggiunge la data attuale impostando orario a 00:00:00.000)
sql ="Update TempSlip Set DataElaborazione=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) Where TempSlip.Carico='#{carico}'"
update_ds = DB_ECAD[sql]
update_ds.update


#----------------------------------------------------Aggiunge Disegni Tecnici Miriam
if carico.include? "C"
  sql="SELECT Numero From Tordine Where Commessa='#{carico}'"   #---lavoro con una commessa
else
  sql="SELECT Numero From Tordine Where Carico='#{carico}'"     #---lavoro con un carico
end
DB_ECAD.fetch(sql) do |riga|
   if (File::exists?("//SRV-GEST/PRNFAX/ASAFAX/S#{riga[:numero]}.pdf"))==true or (File::exists?("//SRV-GEST/PRNFAX/ASAFAX/S#{riga[:numero]}A.pdf"))==true
      FileUtils.cp_r Dir.glob("//SRV-GEST/PRNFAX/ASAFAX/S#{riga[:numero]}*.pdf") , "K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}/" #, :noop => true, :verbose => true
      puts "COPIO DISEGNO TECNICO PER ORDINE:#{riga[:numero]}"
   end
end

numero_anticipi=0
sql="select count(anticipo) as numero_anticipi from tempslip where carico='#{carico}' and anticipo is not null"
DB_ECAD.fetch(sql) do |riga|
  numero_anticipi=riga[:numero_anticipi]
end
if numero_anticipi>0
  system("ruby K:/Ecadpro/RubyLogyUnion/ElaboraAnticipiCarico.rb '#{carico}'")
  puts "Elaborazione Anticipi OK"
end

puts "CARICO #{carico} ELABORATO! PREMI INVIO PER CONTINUARE ..."
gino=STDIN.gets.chomp()
