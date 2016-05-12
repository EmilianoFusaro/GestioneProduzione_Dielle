require "rubygems"
require "prawn"
#require 'barby/outputter/svg_outputter'
require 'prawn-svg'
require 'fileutils'

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="StampaRepartiXCarico"

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"
load "K:/Ecadpro/RubyLogyUnion/CaricaModuloPrelievo.rb"

#-------------------------Elenco Variabili
carico=ARGV[0]
filtro_reparto=ARGV[1]
puts "FILTRO X REPARTO: #{filtro_reparto}"  #---SELCO DEFAULT

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


def genera_report(carico,filtro_reparto,nomestampa)

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
     separatore="rigax[:#{dividi.strip}]" #---con strip elimino spazi vuoti
     #puts separatore

     DB_ECAD.fetch(sql) do |rigax|

      #prima volta necessaria per recuperare il primo ordine in testata
      if conta==0
         testa.split("\n").each{ |rigatesta| eval(TraduciComandi(rigatesta,0)) }
         conta=1 
      end

       #if ((rigax[:pp] != appo_dividi) and (sposta_record>0)) or (sposta_record==220)
       if ((eval(separatore) != appo_dividi) and (sposta_record>0)) or (sposta_record==220)
           pdf.start_new_page
           testa.split("\n").each{ |rigatesta|   
              eval(TraduciComandi(rigatesta,0))
              sposta_record=0
              } 
       end

       rigarecord.split("\n").each{ |rigay|         
        eval(TraduciComandi(rigay,sposta_record))      
       } 

     sposta_record=sposta_record+10
     #appo_dividi=rigax[:"#{dividi}.to_s"]
     #appo_dividi=rigax[:pp]
     appo_dividi=eval(separatore)
     #puts rigax[:"#{dividi}.to_s"]

     end
     
     if carico.include? "C"
       cartella_dest="LACCATI"
     else    
       cartella_dest="CARICHI"
     end
     
     pdf.render_file "K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}/#{nomestampa.gsub(".mst","")}.pdf"
     puts "Stampa :#{nomestampa.gsub("<", "_")} Ok"
     
end

#-----Main()

if carico.include? "C"
  cartella_dest="LACCATI"
else    
  cartella_dest="CARICHI"
end

#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}")
end

genera_report(carico,filtro_reparto,"Stampa_Reparti_X_Carico.mst")



puts "CARICO #{carico} ELABORATO! PREMI INVIO PER CONTINUARE ..."
gino=STDIN.gets.chomp()

