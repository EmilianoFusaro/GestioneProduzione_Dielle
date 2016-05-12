require "rubygems"
require "prawn"
#require 'barby'
#require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
require 'prawn-svg'
require 'fileutils'

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="PrelievoInsertiLaguna"

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


def genera_prelievo_inserti(carico,nomestampa)

     string = IO.read("K:/Ecadpro/RubyLogyUnion/ModuliStampa/#{nomestampa}") #apre il file mette in una stringa

     sql=string.tag("sql")
     testa=string.tag("testa")
     dividi=string.tag("dividi")
     rigarecord=string.tag("record")  
     sql =eval(sql)
  
     pdf = Prawn::Document.new(:page_size => 'A4',:margin => [1])
     pdf.font_size 8 

     conta=0
  
     sposta_record=0
     appo_dividi=""

     conta_cod=0
     appo_cod=""

     DB_3CAD.fetch(sql) do |rigax|

      #puts rigax
      #prima volta necessaria per recuperare il primo ordine in testata
      if conta==0
         testa.split("\n").each{ |rigatesta| eval(TraduciComandi(rigatesta,0)) }
         appo_cod=rigax[:pcod] 
         conta=1         
      end      


       #if (appo_cod !=rigax[:pcod]) or (rigax[:pv2] != appo_dividi)  #divisione pagina per variante - pv2
       if (appo_cod !=rigax[:pcod]) 
          tot_cod=conta_cod.to_s
          conta_cod=rigax[:qta]
          appo_cod=rigax[:pcod]
          #eval(TraduciComandi('LINEAX (1,24,11,24)',sposta_record))
          #eval(TraduciComandi('TESTO (5,30,11,G) "#{tot_cod}"',sposta_record-8))  if sposta_record > 2  
        else
          tot_cod=""
          conta_cod =conta_cod + rigax[:qta]
       end


       #if ((rigax[:pv2] != appo_dividi) and (sposta_record>0)) or (sposta_record>230) #divisione pagina per variante - pv2
       if (sposta_record>230)
           pdf.start_new_page
           testa.split("\n").each{ |rigatesta|   
              eval(TraduciComandi(rigatesta,0))
              sposta_record=0
              } 
       end

       rigarecord.split("\n").each{ |rigay|         
        eval(TraduciComandi(rigay,sposta_record))      
       } 

     sposta_record=sposta_record+8
     #appo_dividi=rigax[:pv2]  #divisione pagina per variante - pv2

     end
     
     
     pdf.render_file "K:/Ecadpro/RubyLogyUnion/CARICHI/#{carico}/#{nomestampa.gsub(".mst","")}.pdf"     
     puts "Stampa :#{nomestampa.gsub("<", "_")} Ok"
     
end

#-----Main()

#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/CARICHI/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/CARICHI/#{carico}")
end

genera_prelievo_inserti(carico,"Stampa_Prelievo_Inserti_Laguna.mst")

