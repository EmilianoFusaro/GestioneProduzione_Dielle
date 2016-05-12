#Questa Procedura genera le distinte in ecad e prepara il file per l'allineamenti in 3cad ,
#l'unica cosa da fare prima di eseguire questa procedure e riempire la tabella SyncArticoli_3Cad con i codici da generare

require 'rubygems'
require "sequel"
Encoding.default_external = 'UTF-8'

DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Dielle;Data Source=10.0.2.8\ECADPRO')  #---Connessione DB Ecad-Dielle


class SyncArticoli_3Cad < Sequel::Model(DB_ECAD[:syncarticoli_3cad])              
   set_primary_key [:cod]
end

class Articoli < Sequel::Model(DB_ECAD[:articoli])              
	set_primary_key [:cod]
end

class Articoli_Appoggio < Sequel::Model(DB_ECAD[:articoli_appoggio])              
	set_primary_key [:cod]
end

class Articoli_Da_Generare < Sequel::Model(DB_ECAD[:articoli_da_generare])              
	set_primary_key [:cod]
end

class Distinta < Sequel::Model(DB_ECAD[:distinta])              
	set_primary_key [:cod,:prog]
end


#Svuota Tabella Articoli_Appoggio
DB_ECAD.run " Delete Articoli_Appoggio"

articoli_da_generare=Articoli_Da_Generare.where("cod like '0%'").all

articoli_da_generare.each do |riga|
  figlio=Articoli_Appoggio.new
  figlio.cod=riga.cod[1..-1]
  figlio.des=riga.des
  figlio.dis=""
  figlio.fl1=""
  figlio.tip=""
  figlio.diml=riga.diml
  figlio.dima=riga.dima
  figlio.dimp=riga.dimp
  figlio.flmodl=riga.flmodl
  figlio.flmoda=riga.flmoda
  figlio.flmodp=riga.flmodp
  figlio.coddx=""
  figlio.pesol=riga.pesol
  figlio.peson=riga.peson
  figlio.catmer="DB"
  figlio.volume=riga.volume
  figlio.reparto=""
  figlio.repartofm=""
  figlio.imballo=""
  figlio.ferrame=0
  figlio.prgmforo=""
  figlio.disbmp=""
  figlio.colmacro=0
  figlio.prezzomlmq=""
  figlio.modello=""
  figlio.neutro=""
  figlio.fornitore=""
  figlio.cdartfor=""
  figlio.prflis=0
  figlio.flmag=0
  figlio.varmag=""
  figlio.codicebarra=""
  figlio.codiva="22"
  figlio.partcont=""
  figlio.collodb=0
  figlio.generatore=""
  figlio.codicedistinta=riga.cod[1..-1]
  figlio.codicealt=""
  figlio.costo=0
  figlio.contferrame=0
  figlio.qtaminima=0
  figlio.var=riga.var
  figlio.tipodistinta=0
  figlio.codiceraee=""
  figlio.capitolato=""
  figlio.fase=""
  figlio.opzmag=""
  figlio.um=""
  figlio.um2=""
  figlio.fconv=0
  figlio.codiceneutro=""
  figlio.progr=0
  figlio.colore=""
  figlio.leadtime=0
  figlio.scminima=0
  figlio.scmassima=0
  figlio.datainventario=riga.datainventario
  figlio.riordino=0
  figlio.consumomedio=0
  figlio.dataum=riga.dataum
  figlio.utenteum=""
  figlio.genecod=nil
  figlio.genevar=nil
  figlio.genflag=0
  figlio.brema=""
  figlio.varbrema=""
  figlio.simul_imbottiti=""
  figlio.settcopertura=0
  figlio.umpianificazione=2
  figlio.cod_identity=nil
  figlio.xlavdx=""
  figlio.xlavsx=""
  figlio.ciclo=""
  figlio.lottoriordino=""
  figlio.cnc=""
  figlio.cncsx=""
  figlio.cncdx=""
  figlio.tipologiaxlav=""
  figlio.tipologiaasa=0
  figlio.tipologiacl=0
  figlio.cncdbalt=0
  figlio.disegnocad=""
  figlio.entity=riga.entity
  figlio.repartomon=nil
  figlio.polpro=nil
  figlio.catmerceologica=nil
  figlio.codlavoraz=nil
  figlio.codicedistintaacc=nil
  figlio.nointernet=nil
  figlio.famiglia=nil
  figlio.fasi=nil
  figlio.codegenemano=nil
  figlio.macrodibordatura=nil
  figlio.save
end

#----------------------------------------------------Aggiunge Date Elaborazione (aggiunge la data attuale impostando orario a 00:00:00.000)
#sql =" Delete Articoli From Articoli Inner Join Articoli_Appoggio On Articoli.Cod = Articoli_Appoggio.Cod "
#delete_ds = DB_ECAD[sql]
#delete_ds.delete

#Cancella GLi Articoli Figli Vecchi Presenti In Anagrafica
DB_ECAD.run " Delete Articoli From Articoli Inner Join Articoli_Appoggio On Articoli.Cod = Articoli_Appoggio.Cod "

#Inserisce Articoli Figli Generati In Anagrafica Articoli
DB_ECAD.run " Insert Into Articoli Select * From Articoli_Appoggio "

#Cancella La Distinta Che Contiene i figli in riga prog=1
DB_ECAD.run " Delete Distinta From Distinta Inner Join Articoli_Da_Generare On Distinta.Cod = Articoli_Da_Generare.Cod Where Prog=1 And Articoli_Da_Generare.Cod like '0%' "

#Cancella Articol Figli da Da Sync
DB_ECAD.run " Delete From  SyncArticoli_3Cad where cod not like '0%' "
#art= gets

articoli_da_generare.each do |riga|
  riga_dist=Distinta.new
  riga_sync=SyncArticoli_3Cad.new  
  riga_dist.cod=riga.cod
  riga_dist.prog=1
  riga_dist.codfig=riga.cod[1..-1]
  riga_dist.qta=1
  riga_dist.valido=""
  riga_dist.dimensioni=""
  riga_dist.fase=""
  riga_dist.tiporiga=0
  riga_dist.save
  riga_sync.cod=riga.cod[1..-1]
  riga_sync.save
end
