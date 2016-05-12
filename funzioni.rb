class Fase
   attr_accessor :codice,:descrizione

   def initialize(codice,descrizione)   	     	  
      @codice=codice
      @descrizione=descrizione
   end

end


def reset_fasi  #cancella tutte le fasi precedenti
  @fase1=nil,@fase2=nil,@fase3=nil,@fase4=nil,@fase5=nil,@fase6=nil,@fase7=nil,@fase8=nil,@fase9=nil
end



#class TrovaFase
#   attr_accessor :codice,:descrizione
#   def initialize(codice)   	     	      
#      return $lista_reparti.detect{|f| f[:codice]==codice}      
#   end  
#end