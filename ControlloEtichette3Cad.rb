require "rubygems"
require "sequel"
require 'timeout'


#---Connessione Database 3Cad Rete
DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                 #---Office


#---Mappatura Tabelle
class Codaoperazioni < Sequel::Model(DB_3CAD[:codaoperazioni])   #---Tabella Processi PrintServer
  set_primary_key [:id]
end

class Tordine < Sequel::Model(DB_3CAD[:tordine])   #---Tabella Tordine
  set_primary_key [:percorso,:numero]
end


#---Identifica Carico O Commessa
#------------------------------------------------------------------------------------------Production
carico=ARGV[0]
filtroordini=ARGV[1]
#---Filtra Solo Alcuni Ordini
if filtroordini == nil  
  $filtroordini=""
else  
  $filtroordini="And Numero in " + "(" + filtroordini.gsub(/\D/,",") + ") " 
end


puts "\nAVVIATA GENERAZIONE ETICHETTE CARICO 3CAD #{carico} ATTENDERE PREGO:\n\n"

if carico.include? "C"
  #tordine=Tordine.where(:commessa=>carico)   
  sql="SELECT Numero From Tordine Where (Commessa='#{carico}' #{$filtroordini}) And (Percorso='DIELLE') Order By Scarico"   #---lavoro con una commessa
else
  #tordine=Tordine.where(:carico=>carico)     
  sql="SELECT Numero From Tordine Where (Carico='#{carico}' #{$filtroordini})  And (Percorso='DIELLE') Order By Scarico"     #---lavoro con un carico
end

ultima_riga=0

DB_3CAD.fetch(sql) do |riga|
  #---Creazione Riga Ordine
  printsrv=Codaoperazioni.new
  printsrv.percorso="DIELLE"
  printsrv.numero=riga[:numero]
  printsrv.operatore="SERVER"
  printsrv.data=Time.now
  printsrv.operazione=1
  printsrv.priorita=20
  printsrv.evasa=false
  printsrv.parametri="CREAETICHETTE"
  printsrv.output=""
  printsrv.escludi=false
  ultima_riga=riga[:numero]
  printsrv.save
end


printsrv=Codaoperazioni.where("numero=#{ultima_riga} and evasa=0")

secondi=0

while printsrv.count>0 do  #lo stato viene rivalutato ogni volta
  sleep 10
  secondi +=10
  puts "Generazione Etichette In Corso Da #{secondi} Secondi..."
end

puts "\nETICHETTE CARICO 3CAD #{carico} GENERATE!\n"
