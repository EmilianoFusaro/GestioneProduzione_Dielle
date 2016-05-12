require "sequel"

class Colore
  #elenco colori
  @colori=["Bianco","Larice","RovereNaturale","Corda","RovereTabacco","OlmoPerla","OlmoNaturale","OlmoLava","Mandarino","Girasole","Magnolia","Alabastro","Avio","VerdePrimavera","Glicine","Acero","Punto","Riga","AcxBianco","AcxTortora","Moro"]
  #elenco opzioni colore
  @opz=   ["1"     ,"3"     ,"D"             ,"6"    ,"K"            ,"4"        ,"7"           ,"C"       ,"8"        ,"m"       ,"5"       ,"A"        ,"l"   ,"9"             ,"B"      ,"2"    ,"a"    ,"k"   ,"e"        ,"f"       ,"w"]   
  #elenco opzioni laccati
  @laccati= ["b","c","E","F","G","H","I","J","L","M","n","O","P","q","R","s","T","U","V","x","Y"]

  #------------------------------------------ colori() -> array dei colori "Bianco","Larice","RovereNaturale" 
  def self.colori()
     @colori
  end
  #------------------------------------------ opzioni() -> array delle opzione colore "001","003","013" 
  def self.opzioni()
     @opz
  end
  #------------------------------------------trova_opz("Bianco")  -> 001
  def self.trova_opz(colore)
     unless @colori.index(colore).nil?
       @opz[@colori.index(colore)]
     else
       nil #opzione di default ma la indico lo stesso
     end
  end
  #------------------------------------------trova_des("001")  -> Bianco
  def self.trova_des(opzione)
     unless @opz.index(opzione).nil?
       @colori[@opz.index(opzione)]
     else
       nil #opzione di default ma la indico lo stesso
     end
  end
  #------------------------------------------trova laccato
  def self.trova_laccato(colore)
   unless @laccati.index(colore).nil?
     true  #trovato
   else
     false #non trovato
   end
  end

end




DB_ASA = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=Simul;Data Source=10.0.2.8')                #----Magazzino Asa
DB_MAG = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')   #----Magazzino Marco


class MagAsa < Sequel::Model(DB_ASA[:magazzinoruby])
  set_primary_key [:codice]
end

class Magazzino < Sequel::Model(DB_MAG[:magazzino])
  set_primary_key [:codice]
end

def TrovaMagazzinoX(riga)

  islaccato=Colore.trova_laccato(riga.codvar)
  
  if islaccato==true 
     colore="Bianco"
  else
     colore=Colore.trova_des(riga.codvar)
  end 

  if colore==nil
    tipologia="COLORE NON PRESENTE"
    return tipologia
  end

  #puts "Test ---> #{riga.codvar} ---> #{colore}"

  trovato=false
  fm_lunghezza=""
  fm_profondita=""
  tipologia=""

  #---------------------------------------------------------------------CONTROLLO NORMALE
  riga.famiglie.split(";").each{ |famiglia| 

   sql_condizione="select top 1 * from magazzino where famiglia='#{famiglia}' and #{colore.downcase}=1 and DimZ=#{riga.dimz} and DimX>=#{riga.dimx} and DimY>=#{riga.dimy} order by dimx,dimy"

   DB_MAG.fetch(sql_condizione) do |r_mag|

    trovato=true
    tipologia="MAGAZZINO"

    if r_mag[:dimx]>riga.dimx
        fm_lunghezza="FM"
        tipologia="MAGAZZINOFM"
    end 
    if r_mag[:dimy]>riga.dimy
        fm_profondita="FM"
        tipologia="MAGAZZINOFM"
    end       
   end   
  
   if trovato==true #se presente in una famiglia interrompo la ricerca    
    return tipologia
    break
   end

  }

  tipologia=""
  #---------------------------------------------------------------------CONTROLLO DA BARRA 
  sql_condizione="select top 1 * from magazzino where famiglia='BARRA' and #{colore.downcase}=1 and DimZ=#{riga.dimz} and DimX>=#{riga.dimx} and DimY>=#{riga.dimy} order by dimx,dimy"

  DB_MAG.fetch(sql_condizione) do |r_mag|

   trovato=true
   tipologia="BARRA"

   if r_mag[:dimx]>riga.dimx
       fm_lunghezza="FM"
       tipologia="BARRAFM"
   end 
   if r_mag[:dimy]>riga.dimy
       fm_profondita="FM"
       tipologia="BARRAFM"
   end       
  end   
   
  if trovato==true #se presente nelle barre interrompo la ricerca
   return tipologia
  end 

  #---------------------------------------------------------------------CONTROLLO DA PANNELLO
  sql_condizione="select top 1 * from magazzino where famiglia='PANNELLO' and #{colore.downcase}=1 and DimZ=#{riga.dimz} and DimX>=#{riga.dimx} and DimY>=#{riga.dimy} order by dimx,dimy"

  DB_MAG.fetch(sql_condizione) do |r_mag|
   trovato=true
   tipologia="PANNELLO"
   fm_lunghezza="FM"
   fm_profondita="FM"
  end   
  
  if trovato==true #se presente nelle barre interrompo la ricerca
   return tipologia    
  end 

  #---------------------------------------------------------------------QUALCOSA NON FUNZIONA NELLA RICERCA
  return "NON TROVATO"  
end

#=begin

righe_asa=MagAsa.all
#righe_asa=MagAsa.where(:fase=>"X").all

righe_asa.each do |riga|
  riga.fase=TrovaMagazzinoX(riga)
  riga.save  
end

#=end

