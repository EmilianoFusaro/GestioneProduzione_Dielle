require "sequel"

#load "k:/ecadpro/rubylogyunion/connessione.rb"  #per testare la classe

$stringa_laccati="501=003;501=004;511=004;570=004;601=003;603=004;700=3;621=2.202;621=3.302;502=003;502=004;502=006;502=009;502=1.102;502=1.104;502=3.302;502=4.402;503=003;503=004;504=004;"
$stringa_laccati=$stringa_laccati + "507=004;510=004;512=003;512=004;573=004;572=004;571=004;569=004;568=004;536=004;535=004;522=009;521=006;521=009;515=003;"
$stringa_laccati=$stringa_laccati + "602=1.102;602=2.202;TVTR=003"  #attenzione a queste 2

#$stringa_laccati_scorrevoli="502=003;502=004;502=006;502=009;502=1.102;502=1.104;502=3.302;502=4.402;"
#attenzione non funzionava 3cad vip laccato 570657 09.03.16
$stringa_laccati_scorrevoli="502=003;502=004;502=006;502=009;502=1.102;502=1.104;502=3.302;502=4.402;602=1.102;602=2.202;"

$maniglie_incasso=["laguna","aster","daytona","monaco","evo","vogue"]

#$stringa_lux=""   #---definisco variante che determina ante lucide

if $nome_file=="ElaboraCarico"

	#DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=eCadPro2008;Initial Catalog=Ecadmaster;Data Source=EMILIANO-PC\ECADPRO2008')   #---Home
	#DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=eCadPro2008;Initial Catalog=Ecadmaster;Data Source=EMILIANO-PC\ECADPRO2008')   #---Home

	DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Office
	DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                 #---Office


	#class Componenti < Sequel::Model(DB_3CAD[:logy_componenti])
	#   #set_primary_key [:category, :title]
	#end

	class Cicli < Sequel::Model(DB_ECAD[:cicli])
		#L'inserimeto delle chiavi nella tabella cicli ha aumentato notevolmente le prestazioni
		set_primary_key [:cod, :padre, :codbarra, :variante, :laccato]
	end

	class Reparti < Sequel::Model(DB_ECAD[:reparti])
		# => include Enumerable
		set_primary_key [:codice]
	end

	#---Da Utilizzare Per Test a Casa
	#class Varianti < Sequel::Model(DB_ECAD[:varianti])
	#	# => include Enumerable
	#	set_primary_key [:codvar,:codopz]
	#end

	#---Attenzione Alcuna Varianti 3cad 511 sono alias in 3cad e non le trova
	#class Varianti < Sequel::Model(DB_3CAD[:varianti])
	#	# => include Enumerable
	#	set_primary_key [:codvar,:codopz]
	#end

	#---Attenzione Alcuna Varianti 3cad 511 sono alias in 3cad e non le trova
	class Varianti < Sequel::Model(DB_ECAD[:rubylogy_var])
		set_primary_key [:codvar,:codopz]
	end

	class TempSlip < Sequel::Model(DB_ECAD[:tempslip])
		# => include Enumerable
		set_primary_key [:carico,:id]
	end

	class Lavorazioni < Sequel::Model(DB_ECAD[:lavorazioni])
	end

	class Magazzino < Sequel::Model(DB_ECAD[:magazzino])
		set_primary_key [:codice]
	end

    class Carico < Sequel::Model(DB_3CAD[:carico])
		set_primary_key [:cod]
		def self.colore_carico(numero_carico)
    	    #self.where(:cod=>'0004').select(:colore).first[:colore]
    	    sql=self.where(:cod=>numero_carico).select(:colore).first
    	    if sql != nil
    	  	  #sql=sql[:colore].to_s(16).rjust(6,"0").reverse
    	  	  sql=sql[:colore].to_s(16).rjust(6,"0")
    	  	  sql=sql[4,2] + sql[2,2] + sql[0,2]
    	  	  if sql=="000000"  #se nero trasformo sempre in bianco
    	  	  	sql="FFFFFF"
    	  	  end
    	  	  return sql
    	  	else
    	  	  return "FFFFFF"
            end
		end
	end
    
    class CaricoComp < Sequel::Model(DB_3CAD[:caricocomp])
      def self.presenza_inserti(numero_carico)
        sql=self.where(:codiceart=>"013500641",:carico=>numero_carico).select(:codiceart).first
        if sql != nil
          return true
        else
          return false
        end
      end
     def self.presenza_tappini_laccati(numero_carico)
        sql=self.where("CARICOCOMP.CARICO='#{numero_carico}' And CARICOCOMP.CODICEART IN ('0CF000063', '0CF000064') And dbo.DescrizioneVarianti3Cad(CARICOCOMP.VARIANTI, '401', 0) like '%Lacc%'").select(:codiceart).first
        if sql != nil
          return true
        else
          return false
        end
        return sql
      end
    end

    class Rordine < Sequel::Model(DB_3CAD[:rordine])
		set_primary_key [:percorso,:numero,:riga]		
		def self.scambia_misure_vo(nordine,rigaordine)                    #inverte misure vena orizzontale solo se y>a (lato vena prima misure)
		  rordine=self.where(:numero=>nordine, :riga=>rigaordine).first   #prima self era Rordine
		  if rordine.dima>rordine.diml
		    rordine.update(:diml=>rordine.dima, :dima=>rordine.diml) 	  #update effettua effettivamente l'aggiornamento sul database 3Cad
		  end
		end
	end

    class RordineEcad < Sequel::Model(DB_ECAD[:rordine])
		set_primary_key [:percorso,:numero,:riga]		
		def self.scambia_misure_vo(nordine,rigaordine)                    #inverte misure vena orizzontale solo se y>a (lato vena prima misure)
		  rordine=self.where(:numero=>nordine, :riga=>rigaordine).first   #prima self era RordineEcad
		  if rordine.dima>rordine.diml
		    rordine.update(:diml=>rordine.dima, :dima=>rordine.diml) 	  #update effettua effettivamente l'aggiornamento sul database Ecad
		  end    
		end
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

	#class Xlavorazioni < Sequel::Model(DB_ECAD[:xlavorazioni])
	#	set_primary_key [:codice]
	#end

elsif $nome_file=="StampaSlip"

	#DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=eCadPro2008;Initial Catalog=Ecadmaster;Data Source=EMILIANO-PC\ECADPRO2008')   #---Home
	DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Office
	DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                 #---Office

	class TempSlip < Sequel::Model(DB_ECAD[:tempslip])
		set_primary_key [:carico,:id]
	end

    class Carico < Sequel::Model(DB_3CAD[:carico])
		set_primary_key [:cod]
		def self.colore_carico(numero_carico)
    	    #self.where(:cod=>'0004').select(:colore).first[:colore]
    	    sql=self.where(:cod=>numero_carico).select(:colore).first
    	    if sql != nil
      	  	  #sql=sql[:colore].to_s(16).rjust(6,"0").reverse
    	  	  sql=sql[:colore].to_s(16).rjust(6,"0")
    	  	  sql=sql[4,2] + sql[2,2] + sql[0,2]
      	  	  if sql=="000000"  #se nero trasformo sempre in bianco
    	  	  	sql="FFFFFF"
    	  	  end
    	  	  return sql
    	  	else
    	  	  return "FFFFFF"
            end
		end
	end

elsif $nome_file=="StampaPrelievi" or $nome_file=="StampaLaccati"

	#DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=eCadPro2008;Initial Catalog=Ecadmaster;Data Source=EMILIANO-PC\ECADPRO2008')   #---Home
	DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Office
	DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                 #---Office


	class TempSlip < Sequel::Model(DB_ECAD[:tempslip])
		set_primary_key [:carico,:id]
	end

	class TipoStampa < Sequel::Model(DB_ECAD[:tipostampa])
		set_primary_key [:codice]
	end

	class Lavorazioni < Sequel::Model(DB_ECAD[:lavorazioni])
		set_primary_key [:codice]
	end

	class Carico < Sequel::Model(DB_3CAD[:carico])
		set_primary_key [:cod]
		def self.colore_carico(numero_carico)
    	    #self.where(:cod=>'0004').select(:colore).first[:colore]
    	    sql=self.where(:cod=>numero_carico).select(:colore).first
    	    if sql != nil
      	  	  #sql=sql[:colore].to_s(16).rjust(6,"0").reverse
	  	  	  sql=sql[:colore].to_s(16).rjust(6,"0")
    	  	  sql=sql[4,2] + sql[2,2] + sql[0,2]
      	  	  if sql=="000000"  #se nero trasformo sempre in bianco
    	  	  	sql="FFFFFF"
    	  	  end
      	  	  return sql
    	  	else
    	  	  return "FFFFFF"
            end
		end
	end

elsif $nome_file=="StampaRepartiXCarico"

	DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Office


	class TempSlip < Sequel::Model(DB_ECAD[:tempslip])
		set_primary_key [:carico,:id]
	end

	class TipoStampa < Sequel::Model(DB_ECAD[:tipostampa])
		set_primary_key [:codice]
	end

	class Lavorazioni < Sequel::Model(DB_ECAD[:lavorazioni])
		set_primary_key [:codice]
	end

	class Reparti < Sequel::Model(DB_ECAD[:reparti])
		# => include Enumerable
		set_primary_key [:codice]
	end

	class Magazzino < Sequel::Model(DB_ECAD[:magazzino])
		set_primary_key [:codice]
	end

	#class Xlavorazioni < Sequel::Model(DB_ECAD[:xlavorazioni])
	#	set_primary_key [:codice]
	#end

    class Carico < Sequel::Model(DB_3CAD[:carico])
		set_primary_key [:cod]
		def self.colore_carico(numero_carico)
    	    #self.where(:cod=>'0004').select(:colore).first[:colore]
    	    sql=self.where(:cod=>numero_carico).select(:colore).first
    	    if sql != nil
    	  	  #sql=sql[:colore].to_s(16).rjust(6,"0").reverse
    	  	  sql=sql[:colore].to_s(16).rjust(6,"0")
    	  	  sql=sql[4,2] + sql[2,2] + sql[0,2]
      	  	  if sql=="000000"  #se nero trasformo sempre in bianco
    	  	  	sql="FFFFFF"
    	  	  end
    	  	  return sql
    	  	else
    	  	  return "FFFFFF"
            end
		end
	end

else   #Attualmente Utilizzato Come Test

	DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #---Office
    DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')                 #---Office

	class TempSlip < Sequel::Model(DB_ECAD[:tempslip])
		set_primary_key [:carico,:id]
	end

	class TipoStampa < Sequel::Model(DB_ECAD[:tipostampa])
		set_primary_key [:codice]
	end

	class Lavorazioni < Sequel::Model(DB_ECAD[:lavorazioni])
		set_primary_key [:codice]
	end

	class Reparti < Sequel::Model(DB_ECAD[:reparti])
		# => include Enumerable
		set_primary_key [:codice]
	end

	class Magazzino < Sequel::Model(DB_ECAD[:magazzino])
		set_primary_key [:codice]
	end

	class MaterialeRecupero < Sequel::Model(DB_ECAD[:materialerecupero])
		set_primary_key [:codice]
	end

	#class Xlavorazioni < Sequel::Model(DB_ECAD[:xlavorazioni])
	#	set_primary_key [:codice]
	#end

    class Carico < Sequel::Model(DB_3CAD[:carico])
		set_primary_key [:cod]
		def self.colore_carico(numero_carico)
    	    #self.where(:cod=>'0004').select(:colore).first[:colore]
    	    sql=self.where(:cod=>numero_carico).select(:colore).first
    	    if sql != nil
    	  	  #sql=sql[:colore].to_s(16).rjust(6,"0").reverse
    	  	  sql=sql[:colore].to_s(16).rjust(6,"0")
    	  	  sql=sql[4,2] + sql[2,2] + sql[0,2]
      	  	  if sql=="000000"  #se nero trasformo sempre in bianco
    	  	  	sql="FFFFFF"
    	  	  end
    	  	  return sql
    	  	else
    	  	  return "FFFFFF"
            end
		end
	end

end


#load "k:/ecadpro/rubylogyunion/connessione.rb"  #per testare la classe
