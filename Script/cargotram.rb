##script per la gestione dei cicli delle tramezze CARGO
load "K:/ecadpro/RubyLogy/funzioni.rb"


if @riga[:varianti].include?("501=001") and @riga[:varianti].include?("401=001")
	    reset_fasi  #cancella tutte le fasi precedenti
        @fase1=Fase.new("2255","SEMILAVORATI CARGO - MODUS")
		@fase2=Fase.new("4040","BIESSE INSIDER")
		@fase3=Fase.new("4015","PLANET")
		@fase4=Fase.new("500","CONTROLLO FM")
elsif @riga[:varianti].include?("501=001") and @riga[:varianti].include?("401=001")==false
	    reset_fasi  #cancella tutte le fasi precedenti
        @fase1=Fase.new("1681","PREL PANNELLI SALVADOR")
		@fase2=Fase.new("2010","SALVADOR")
		@fase3=Fase.new("3315","HOMAG 1 LATO 14/10 + 3 LATI")
		@fase4=Fase.new("4040","BIESSE INSIDER")
		@fase5=Fase.new("4015","PLANET")
		@fase6=Fase.new("500","CONTROLLO FM")
elsif @islaccato==true
	    reset_fasi  #cancella tutte le fasi precedenti
        @fase1=Fase.new("2255","SEMILAVORATI CARGO - MODUS")
		@fase2=Fase.new("99","PRELIEVO LACCATURA")
		@fase3=Fase.new("4040","BIESSE INSIDER")
		@fase4=Fase.new("4015","PLANET")
		@fase5=Fase.new("98","BANCALE PER LACCATURA")
end


