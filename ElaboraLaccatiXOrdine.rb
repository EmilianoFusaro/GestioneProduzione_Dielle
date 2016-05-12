require "rubygems"
require "prawn"
#require 'barby'
#require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
require 'prawn-svg'
require 'fileutils'

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="StampaLaccati"

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"
load "K:/Ecadpro/RubyLogyUnion/CaricaModuloPrelievo.rb"

#-------------------------Elenco Variabili
carico=ARGV[0]

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

def genera_laccato(carico,nomestampa)

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

     DB_ECAD.fetch(sql) do |rigax|

      #prima volta necessaria per recuperare il primo ordine in testata
      if conta==0
         testa.split("\n").each{ |rigatesta| eval(TraduciComandi(rigatesta,0)) }
         conta=1 
      end

       if ((rigax[:numero] != appo_dividi) and (sposta_record>0)) or (sposta_record==220)
           pdf.start_new_page
           testa.split("\n").each{ |rigatesta|   
              eval(TraduciComandi(rigatesta,0))
              sposta_record=0
              } 
       end

       rigarecord.split("\n").each{ |rigay|         
        eval(TraduciComandi(rigay,sposta_record))      
       } 

     #puts rigax[1,1]
     #puts rigax[:numero] 

     sposta_record=sposta_record+10
     #appo_dividi=rigax[:"#{dividi}.to_s"]
     appo_dividi=rigax[:numero]
     #puts rigax[:"#{dividi}.to_s"]

     end
     
     
     pdf.render_file "K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}/#{nomestampa.gsub(".mst","")}.pdf"
     puts "Stampa :#{nomestampa.gsub("<", "_")} Ok"
     
end

#-----Main()

#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}")
end

#genera_laccato(carico,"K:/Ecadpro/RubyLogyUnion/ModuliStampa/ElaboraLaccatoA.mst")
genera_laccato(carico,"Stampa_Laccati_X_Ordine.mst")

