require "rubygems"
require "sequel"
require 'timeout'

#---Connessione Database
#DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=eCadPro2008;Initial Catalog=Ecadmaster;Data Source=EMILIANO-PC\ECADPRO2008')   #---Home
DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Office


#---Mappatura Tabelle
class Printsrv < Sequel::Model(DB_ECAD[:printsrv])   #---Tabella Processi PrintServer
  set_primary_key [:id]
end

class Tordine < Sequel::Model(DB_ECAD[:tordine])   #---Tabella Tordine
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
#------------------------------------------------------------------------------------------Test
#carico="0202"
#filtroordini=""

puts "\nAVVIATA RIVALUTAZIONE CARICO #{carico} ATTENDERE PREGO:\n\n"

if carico.include? "C"
  #tordine=Tordine.where(:commessa=>carico)   
  sql="SELECT Numero From Tordine Where Commessa='#{carico}' #{$filtroordini} Order By Scarico"   #---lavoro con una commessa
else
  #tordine=Tordine.where(:carico=>carico)     
  sql="SELECT Numero From Tordine Where Carico='#{carico}' #{$filtroordini} Order By Scarico"     #---lavoro con un carico
end	

#printsrv=Printsrv

ultima_riga=0

DB_ECAD.fetch(sql) do |riga|

  #---Creazione Riga Ordine
  printsrv=Printsrv.new
  printsrv.percorso="_ECADPRO"
  printsrv.numero=riga[:numero]
  printsrv.operatore="ADMINISTRATOR"
  printsrv.data=Time.now
  printsrv.operazione=3
  printsrv.priorita=20
  printsrv.evasa=false
  printsrv.parametri="VBS"
  printsrv.output="RIVALUTA"
  printsrv.escludi=false
  ultima_riga=riga[:numero]
  printsrv.save

end

#-----------------------------------------------------------------------------------------Con Email Di Conferma
#---Creazione Riga Finale
#printsrv=Printsrv.new
#printsrv.percorso="_ECADPRO"
#printsrv.numero=ultima_riga
#printsrv.operatore="ADMINISTRATOR"
#printsrv.data=Time.now
#printsrv.operazione=0
#printsrv.priorita=20
#printsrv.evasa=false
#printsrv.parametri="VBS finito xxx"
#printsrv.output="EMAIL"
#printsrv.escludi=false
#printsrv.save
#printsrv=Printsrv.where("output='EMAIL' and numero=#{ultima_riga} and evasa=0")


#Printsrv.last[:numero] #numero ordine dell'ultima riga 

#-----------------------------------------------------------------------------------------Senza Email Di Conferma
printsrv=Printsrv.where("numero=#{ultima_riga} and evasa=0")

secondi=0

while printsrv.count>0 do  #lo stato viene rivalutato ogni volta
  sleep 10
  secondi +=10
  puts "Rivaluta Carico In Corso Da #{secondi} Secondi..."
end

puts "\nRIVALUTAZIONE CARICO #{carico} COMPLETATA!\n"

#load 'c:/Users/emiliano fusaro/Desktop/ControlloRivalutaCarico.rb'