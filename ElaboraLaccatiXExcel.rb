require "rubygems"
require 'fileutils'
require 'axlsx'

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="StampaLaccati"

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"


#-------------------------Elenco Variabili
carico=ARGV[0]


def genera_laccato(carico,nomestampa)

	p = Axlsx::Package.new
 
	# Required for use with numbers
	p.use_shared_strings = true

	sql="Select count(Qta) as qta,Numero,Pcod,Pdes,PL,PA,PP,dbo.ESTRAI(PV2,'=',2) as PV2 from TempSlip where carico like '#{carico}' and ISLACCATO=1 group by qta,Numero,Pcod,Pdes,PL,PA,PP,dbo.ESTRAI(PV2,'=',2)  order by pv2,pcod,numero "

    appo_dividi=""
    wb=nil            #se lo dichiaro dentro if la sua validità e limitata al "then"
    conta=1

    DB_ECAD.fetch(sql) do |rigax|

    	if (rigax[:pv2] != appo_dividi)
            conta +=1
            wb=p.workbook.add_worksheet(:name => "#{rigax[:pv2]}")
            wb.add_row ['NR.ORDINE','PEZZI','COD.ART','DESCRIZIONE','MISURA','MISURA','MISURA','','','METRI QUADRI'] 
            appo_dividi=rigax[:pv2]
            puts appo_dividi        
    	end
        
        wb.add_row [rigax[:numero],rigax[:qta],rigax[:pcod],rigax[:pdes],rigax[:pl],rigax[:pa],rigax[:pp],'','',((rigax[:pl]/1000) * (rigax[:pa]/1000) * rigax[:qta])]   
        
    end

	p.serialize "K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}/#{nomestampa}"

end

#-----Main()
#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/LACCATI/#{carico}")
end

genera_laccato(carico,"ListaLaccati.xlsx")

