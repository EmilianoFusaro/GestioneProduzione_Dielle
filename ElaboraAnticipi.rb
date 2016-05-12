#Elabora Anticipi 04.11.14 Emiliano

require "rubygems"
require "sequel"
require "prawn"
#require 'barby/outputter/svg_outputter'   #x stampare codebar
require 'prawn-svg'
require 'fileutils'
require 'date'

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="StampaRepartiXCarico"
$reparti=[]

DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Connessione Ecad
##DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')               #---Connessione 3cad al momento disattivata

class Lista_Anticipi < Sequel::Model(DB_ECAD[:lista_anticipi])
  # => include Enumerable	
  set_primary_key [:codart]
end

class Anticipi < Sequel::Model(DB_ECAD[:anticipi])
  # => include Enumerable	
  set_primary_key [:cod]
  def self.cerca(codice)
    #sql=self.where(:cod=>codice).select(:anticipo).first.to_h #forzo il risultato in un hash
	#return sql
	sql=self.where(:cod=>codice).select(:anticipo).first #forzo il risultato in un hash
	if sql!=nil
	  sql=sql[:anticipo].to_s
    end	
	return sql
  end
end

class Tordine < Sequel::Model(DB_ECAD[:tordine])
  # => include Enumerable	
  set_primary_key [:percorso,:numero]
  def self.nr_settimana(numero_ordine)
    settimana=0
    sql=self.where(:numero=>numero_ordine).select(:data).first
	if sql!=nil
	  settimana=DateTime.parse(sql[:data].to_s)  #Trasforma Una Stringa In Data
	  settimana=settimana.cweek	                 #Restituisce La Settimana Corrente Di Quella Data  
	end
	return settimana
  end	
end

load "K:/Ecadpro/RubyLogyUnion/CaricaModuloPrelievo.rb"

numero=ARGV[0]

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


def genera_report(numero,percorso,nomestampa,nome_file)

     string = IO.read("K:/Ecadpro/RubyLogyUnion/ModuliStampa/#{nomestampa}") #apre il file mette in una stringa

     sql=string.tag("sql")
     testa=string.tag("testa")
     dividi=string.tag("dividi")
     rigarecord=string.tag("record")  
     sql =eval(sql)
  
     pdf = Prawn::Document.new(:page_size => 'A4',:margin => [1])
     pdf.font_size 8 

     conta=0
     #testa.split("\n").each{ |rigatesta|   
     #   eval(TraduciComandi(rigatesta,0))
     #} 
  
     sposta_record=0
     appo_dividi=""
	 
     ##dividi="pp"
     separatore="rigax[:#{dividi.strip.downcase}]" #---con strip elimino spazi vuoti (deve arrivare in minuscolo)
     #puts separatore

     DB_ECAD.fetch(sql) do |rigax|

      #prima volta necessaria per recuperare il primo ordine in testata
      if conta==0
         testa.split("\n").each{ |rigatesta| eval(TraduciComandi(rigatesta,0)) }
		 $reparti << eval(separatore) #memorizza la descrizione del 1° anticipo
         conta=1 
      end

       #if ((rigax[:pp] != appo_dividi) and (sposta_record>0)) or (sposta_record==220)	   
       if ((eval(separatore) != appo_dividi) and (sposta_record>0)) or (sposta_record==225) #numero di record considerando multipli di 10 --- 22 righe  15 -- 15 righe
           pdf.start_new_page
           testa.split("\n").each{ |rigatesta|   
              eval(TraduciComandi(rigatesta,0))
              sposta_record=0
              } 
		    $reparti << eval(separatore) #memorizza la descrizione degli altri anticipi
       end

       rigarecord.split("\n").each{ |rigay|         
        eval(TraduciComandi(rigay,sposta_record))      
       } 

     sposta_record=sposta_record+15
     #appo_dividi=rigax[:"#{dividi}.to_s"]
     #appo_dividi=rigax[:pp]
     appo_dividi=eval(separatore)
     #puts rigax[:"#{dividi}.to_s"]

     end
          
   #pdf.render_file "#{percorso}/#{nomestampa.gsub(".mst","")}.pdf"
	 #pdf.render_file "#{percorso}/Anticipi_#{numero}.pdf"
	 pdf.render_file "#{percorso}/#{nome_file}"
   #puts "Stampa :#{nomestampa.gsub("<", "_")} Ok"
     
end


#-----Main()

settimana=Tordine.nr_settimana(numero)

#------------------------------------Se Non Presente Crea La Directory Con il Numero Della Settimana
unless File.directory?("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}")
  ##puts Dir["K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}/*#{ordine}*"].length
end

#------------------------------------Verifica L'esistenza Di Altri File E Rinumera
numeratore=1
Dir.foreach("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}/").each do |item|
  if item.include? numero                #prendo solo quell'ordine
    numeratore=numeratore+1  
  end
end

nome_file="Anticipi_#{numero}_#{numeratore.to_s.rjust(2,"0")}.pdf"

percorso="K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}"

genera_report(numero,percorso,"Stampa_Anticipi.mst",nome_file)

#puts $reparti.to_s

if 1==1
#-------------------------------------------------------Invio Mail Html Miriam
require 'net/smtp' 
message = <<EOF
From: Elaborazione Anticipi<fusaro@dielle.it>
To: RECEIVER <binotto@dielle.it>
MIME-Version: 1.0
Content-type: text/html
Subject: Anticipo Settimana #{settimana} Ordine #{numero}
Presenza Anticipo Settimana #{settimana} Ordine #{numero}
Questo e' Il #{numeratore} Anticipo Dell' Ordine #{numero}
Anticipi presenti: #{$reparti}
EOF
 
smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls
smtp.start('gmail.com', 'fusaro@dielle.it', 'sole33', :login)
smtp.send_message message, 'fusaro@dielle.it', 'binotto@dielle.it'
smtp.finish
end

#puts "CARICO #{carico} ELABORATO! PREMI INVIO PER CONTINUARE ..."
#risposta_user=STDIN.gets.chomp()
