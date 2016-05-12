class Colore
  #@Bianco="022=001;022=611;201=611;401=001;401=611;402=001;402=611;407=001;409=001;410=001;411=001;411=611;412=001;412=501;413=001;415=001;421=001;422=001;430=001;432=130;435=001;436=001;468=001;469=001;470=001;471=001;472=001;473=001;580=346;581=356;581=366;BSM=002;"
  #@Larice="022=003;022=633;401=003;401=633;402=003;402=633;407=003;409=003;410=003;411=003;412=003;413=003;415=003;421=003;422=003;430=003;435=003;436=003;468=003;469=003;470=003;471=003;472=003;"
  #@RovereNaturale="022=013;401=013;407=013;409=013;410=013;411=013;412=013;413=013;415=013;421=013;422=013;430=013;435=013;436=013;468=013;469=013;470=013;471=013;472=013;473=013;"
  #@Corda="022=006;401=006;402=006;407=006;409=006;410=006;411=006;412=006;413=006;415=006;421=006;422=006;430=006;435=006;436=006;468=006;469=006;470=006;471=006;472=006;"
  #@RovereTabacco="022=018;401=018;407=018;409=018;410=018;411=018;412=018;413=018;415=018;421=018;422=018;430=018;435=018;436=018;468=018;469=018;470=018;471=018;472=018;473=018;"
  #@OlmoPerla="022=004;401=004;407=004;409=004;410=004;411=004;412=004;413=004;415=004;422=004;430=004;435=004;436=004;468=004;469=004;470=004;471=004;472=004;"
  #@OlmoNaturale="022=007;401=007;407=007;409=007;410=007;411=007;412=007;413=007;415=007;422=007;430=007;435=007;436=007;468=007;469=007;470=007;471=007;472=007;"
  #@OlmoLava="022=012;401=012;407=012;409=012;410=012;411=012;412=012;413=012;415=012;422=012;430=012;435=012;436=012;468=012;469=012;470=012;471=012;472=012;"
  #@Mandarino="022=008;401=008;407=008;409=008;410=008;411=008;412=008;413=008;415=008;421=008;422=008;430=008;432=131;435=008;436=008;468=008;469=008;470=008;"
  #@Girasole="022=014;401=014;407=014;409=014;410=014;411=014;412=014;413=014;415=014;421=014;422=014;430=014;435=014;436=014;468=014;469=014;470=014;"
  #@Magnolia="022=005;401=005;402=005;402=655;407=005;409=005;410=005;411=005;412=005;413=005;415=005;421=005;422=005;430=005;435=005;436=005;468=005;469=005;470=005;471=005;472=005;473=005"
  #@Alabastro="022=016;401=016;407=016;409=016;410=016;411=016;412=016;413=016;415=016;421=016;422=016;430=016;435=016;436=016;468=016;469=016;470=016;"
  #@Avio="022=015;401=015;407=015;409=015;410=015;411=015;412=015;413=015;415=015;422=015;430=015;435=015;436=015;468=015;469=015;470=015;"
  #@VerdePrimavera="022=009;401=009;407=009;409=009;410=009;411=009;412=009;413=009;415=009;421=009;422=009;430=009;435=009;436=009;468=009;469=009;470=009;"
  #@Glicine="022=011;401=011;407=011;409=011;410=011;411=011;412=011;413=011;415=011;421=011;422=011;430=011;435=011;436=011;468=011;469=011;470=011;"

  #elennco varianti che rappresentano i colori
  @varianticolore=["001","003","021","022","023","041","080","081","201","401","402","404","407","409","410","411","412","413","415","421","422","430","432","435","436","468","469","470","471","472","473"]
  #elenco colori
  @colori=["Bianco","Larice","RovereNaturale","Corda","RovereTabacco","OlmoPerla","OlmoNaturale","OlmoLava","Mandarino","Girasole","Magnolia","Alabastro","Avio","VerdePrimavera","Glicine","Punto","Riga","AcxBianco","AcxTortora","Moro","OlmoCenere"]
  #elenco opzioni colore
  @opz=   ["001"   ,"003"   ,"013",           "006"  ,"018"          ,"004"      ,"007"         ,"012"     ,"008"      ,"014"     ,"005"     ,"016"      ,"015" ,"009"           ,"011"     ,"083"  ,"082"  ,"501"      ,"502"       ,"017","002"]   

  #def self.trova(variante)
  #  return "Bianco"          if (@@Bianco.include?         variante)
  #  return "Larice"          if (@@Larice.include?         variante) 
  #  return "RovereNaturale"  if (@@RovereNaturale.include? variante) 
  #  return "Corda"           if (@@Corda.include?          variante) 
  #  return "RovereTabacco"   if (@@RovereTabacco.include?  variante) 
  #  return "OlmoPerla"       if (@@OlmoPerla.include?      variante) 
  #  return "OlmoNaturale"    if (@@OlmoNaturale.include?   variante) 
  #  return "OlmoLava"        if (@@OlmoLava.include?       variante) 
  #  return "Mandarino"       if (@@Mandarino.include?      variante) 
  #  return "Girasole"        if (@@Girasole.include?       variante) 
  #  return "Magnolia"        if (@@Magnolia.include?       variante) 
  #  return "Alabastro"       if (@@Alabastro.include?      variante) 
  #  return "Avio"            if (@@Avio.include?           variante) 
  #  return "VerdePrimavera"  if (@@VerdePrimavera.include? variante) 
  #  return "Glicine"         if (@@Glicine.include?        variante) 
  #  return nil
  #end

  #------------------------------------------ varianticolore() -> array delle varianti colore "401","412","412" 
  def self.varianticolore()
     @varianticolore
  end
   
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

  #-----------------------------------------trova_var("501=001;401=001") -> true
  def self.trova_var(variante)
     @varianticolore.include?(variante) 
  end


  #-----------------------------------------trova_varopz("401=001") -> Bianco
  def self.trova_varopz(variante)
    if trova_var(variante.split("=")[0])==true
        trova_des(variante.split("=")[1])    
    end    
  end


  #-----------------------------------------trova_strvaropz("501=001;401=001;404=303;") -> Bianco .downcase .upcase .capitalize
  def self.trova_strvaropz(variante)    
   variante.split(";").each{ |i| 
    if trova_var(i.split("=")[0])==true
      colore=trova_des(i.split("=")[1])  
      unless colore.nil?    
        return colore
      end
    end    
   }
   return nil
  end


  #--------------------------propietà get-set
  #def age        #----------Esempio Get
  #  @age
  #end

  #def age=(age)  #----------Esempio Set
  #  @age
  #end

end


class CicloMagazzino

  attr_accessor :riga,:riga_magazzino,:fm_lunghezza,:fm_profondita,:islaccato,:tipologia

  def initialize(_riga,_riga_magazzino,_fm_lunghezza,_fm_profondita,_islaccato,_tipologia)
    @riga = _riga
    @riga_magazzino = _riga_magazzino
    @fm_lunghezza=_fm_lunghezza
    @fm_profondita=_fm_profondita
    @islaccato=_islaccato
    @tipologia=_tipologia
  end

end
