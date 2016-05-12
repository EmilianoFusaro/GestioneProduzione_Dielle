require "rubygems"
#$nome_file=__FILE__     #specifica nella connessione il file chiamante forse anche $0
require "prawn"
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
require 'prawn-svg'
require 'fileutils'
#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="ElaboraCarico"

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"
load "K:/Ecadpro/RubyLogyUnion/CaricaModuloStampa.rb"

#-------------------------Elenco Variabili
carico=ARGV[0]
filtroordini=ARGV[1]

unless defined? $lista_varianti
	$lista_varianti=Varianti.all   #da utilizzare se il modulo è lanciato da solo (istruzione già presente in elaboracaricoxx.rb) 	
end 

if carico.include? "XXXX"
  modulo_originale1=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti_test.mst",0,0)
  modulo_originale2=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti_test.mst",427,0)
  modulo_originale3=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti_test.mst",0,-280)
  modulo_originale4=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti_test.mst",427,-280)
else
  modulo_originale1=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti.mst",0,0)
  modulo_originale2=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti.mst",427,0)
  modulo_originale3=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti.mst",0,-280)
  modulo_originale4=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_mancanti.mst",427,-280)
end  



#-------------------------Filtra Solo Alcuni Ordini
if filtroordini == nil  
  $filtroordini=""
else  
  $filtroordini="And Tordine.Numero in " + "(" + filtroordini.gsub(/\D/,",") + ") " 
end


def TraduciVarianti(stringavariante)  #devo passare il valore come --> TraduciVariante(var[4])  if var[4].size>2
	#varianti.split(";")[41] if defined? "si":"no" esempio if else in linea
	if (defined? stringavariante.split('=')[0]) and (defined? stringavariante.split('=')[1])		
	    appo_var=$lista_varianti.select{|f| f.codvar=="#{stringavariante.split('=')[0]}" and f.codopz=="#{stringavariante.split("=")[1]}"}
	    if appo_var.count==1
        	return appo_var[0].des
    	else      
	        return ""
	    end 
	else
	  return ""
	end       
end

sql = "SELECT RORDINE.NUMERO, RORDINE.RIGA, RORDINE.ETI, RORDINE.TIPORIGA, RORDINE.CODART, RORDINE.DES, RORDINE.NOTE1, RORDINE.NOTE2, RORDINE.NOTE3, "
sql += " RORDINE.NOTE4, RORDINE.NOTE5, RORDINE.PZ, RORDINE.[VAR], RORDINE.DIML, RORDINE.DIMA, RORDINE.DIMP, RORDINE.MATRICOLA, RORDINE.FM, "
sql += " RORDINE.QTA, TORDINE.CARICO , TORDINE.COMMESSA FROM  RORDINE LEFT OUTER JOIN EcadTempSlip ON RORDINE.RIGA = EcadTempSlip.RIGA AND RORDINE.NUMERO = EcadTempSlip.Numero AND "
sql += " RORDINE.CODART = EcadTempSlip.PCOD RIGHT OUTER JOIN TORDINE ON RORDINE.NUMERO = TORDINE.Numero AND RORDINE.PERCORSO = TORDINE.PERCORSO "
sql += " WHERE (TORDINE.COMMESSA = '#{carico}' #{$filtroordini}) AND (EcadTempSlip.PCOD IS NULL) AND (RORDINE.TIPORIGA = '3') AND (RORDINE.[VAR] LIKE '%=%') Order By RORDINE.NUMERO,RORDINE.RIGA"

#DB_ECAD.Timeout=100

pdf = Prawn::Document.new(:page_size => 'A4',:page_layout => :landscape,:margin => [1])
pdf.font_size 8 
conta_slip=1

DB_3CAD.fetch(sql) do |riga|

  variante=riga[:var].split(";")
  
  variante.each{ |i| 
  	if ($stringa_laccati.include? i) and (i.size>=6)
  		rigatrovata= "#{riga[:codart]} #{riga[:des]} #{riga[:var]} \n"
  		 #File.open("lista_laccatimancanti.txt", 'a') { |file| file.write(rigatrovata) } #genera file txt x Test
  		 case conta_slip
  		 when 1
  			eval(modulo_originale1)  
  		 when 2
 	  		eval(modulo_originale2)  
  		 when 3
  			eval(modulo_originale3)  
  		 when 4
  			eval(modulo_originale4)
  			conta_slip=0
  			pdf.start_new_page
  		 end 	

         conta_slip=conta_slip+1  

  		break #interrompe if 
  	end
  }

end


#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}")
end

pdf.render_file "K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}/#{carico}_SlipCicliMancantiLaccati.pdf"
