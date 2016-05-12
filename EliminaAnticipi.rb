#Elimina Anticipi 08.11.14 Emiliano
require 'fileutils'
require "rubygems"
require "sequel"
require 'fileutils'
require 'date'
#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'



DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Connessione Ecad
##DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')               #---Connessione 3cad al momento disattivata


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

ordine=ARGV[0]


if ordine!=nil and ordine.to_s.size==6

  settimana=Tordine.nr_settimana(ordine)
  
  if File.directory?("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}") 
    #FileUtils.rm_rf(Dir.glob("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}/*#{ordine}*"))  #Elimina Il File Corrente	
	Dir.foreach("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}/").each do |item|
	  if item.include? ordine                #prendo solo quell'ordine
	    unless item.include? "Eliminato_"     #verifico se già eliminato
		  FileUtils.mv("K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}/#{item}", "K:/Ecadpro/RubyLogyUnion/Anticipi/Settimana_#{settimana}/Eliminato_#{item}")  #rinomino il file antecedendo "Eliminato_"
		end
	  end
	end	
  end 
  
#-------------------------------------------------------Invio Mail Html Miriam (il testo deve essere allineato a sinistra )
if 1==1
require 'net/smtp' 
message = <<EOF
From: ANTICIPO ELIMINATO<fusaro@dielle.it>
To: RECEIVER <binotto@dielle.it>
MIME-Version: 1.0
Content-type: text/html
Subject: ANTICIPO ELIMINATO Settimana #{settimana} Ordine #{ordine}
ANTICIPO ELIMINATO Settimana #{settimana} Ordine #{ordine}
EOF
   
smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls
smtp.start('gmail.com', 'fusaro@dielle.it', 'sole33', :login)
smtp.send_message message, 'fusaro@dielle.it', 'binotto@dielle.it'
smtp.finish
end
end






