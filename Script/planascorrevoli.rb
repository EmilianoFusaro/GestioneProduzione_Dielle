load "K:/ecadpro/RubyLogy/funzioni.rb"

#Script per la produzione delle ante scorrevoli PLANA


#Gestione delle fasce orizzontali
if @riga[:descrizione].include? "ANTA PLANA FASCIA ORIZZONTALE"
  #puts "fascia orizzontale"
	@riga[:rl]=@riga[:ra]-400
	@riga[:ra]=@riga[:a]
	@riga[:rp]=@riga[:p]
	#---misure padre come sopra
	@riga[:pl]=@riga[:rl]
	@riga[:pa]=@riga[:ra]
	@riga[:pp]=@riga[:rp]
	
	@riga[:pdes]="FASCIA ORIZZONTALE X" + "\n" + @riga[:pdes]	
    @riga[:pvarianti]=@riga[:varianti]

	reset_fasi  #cancella tutte le fasi precedenti
	@fase1=Fase.new("1106","PREL.FASCE PLANA SCORR")
	@fase2=Fase.new("60","ASSEMBLAGGIO ANTE MODUS")

elsif @riga[:descrizione].include? "ANTA PLANA FASCIA VERTICALE"
  #puts "fascia orizzontale"
  #@riga[:rl]=@riga[:l]
  @riga[:ra]=@riga[:a]
  @riga[:rp]=@riga[:p]
  #---misure padre come sopra
  @riga[:pl]=@riga[:rl]
  @riga[:pa]=@riga[:ra]
  @riga[:pp]=@riga[:rp]
  
  @riga[:pdes]="FASCIA VERITCALE X" + "\n" + @riga[:pdes]
  @riga[:pvarianti]=@riga[:varianti]

  reset_fasi  #cancella tutte le fasi precedenti
  @fase1=Fase.new("1106","PREL.FASCE PLANA SCORR")
  @fase2=Fase.new("60","ASSEMBLAGGIO ANTE MODUS")

elsif @riga[:descrizione].include? "ANTA PLANA PANNELLO"

  #@riga[:pl]=@riga[:l]
  #@riga[:pa]=@riga[:a]
  #@riga[:pp]=@riga[:p]
  #@riga[:rl]=@riga[:l]
  #@riga[:ra]=@riga[:a]
  #@riga[:rp]=@riga[:p]

  @riga[:pdes]="PANNELLO X" + "\n" + @riga[:pdes]
  
  reset_fasi  #cancella tutte le fasi precedenti
  @fase1=Fase.new("1680","PREL PANNELLI")
  @fase2=Fase.new("20001","SELCO")
  @fase3=Fase.new("4015","PLANET X CANALI")
  @fase4=Fase.new("60","ASSEMBLAGGIO ANTE MODUS")
  @fase5=Fase.new("4015","PLANET")
  @fase6=Fase.new("500","CONTROLLO FM")

end

#la larghezza delle AnteScorr devono generare un pannello 20 mm più corto e di spoessore 18
#-----------------------------Disattivati Per Problemi Virgilio Con Descrizioni
#@riga[:a]=@riga[:a]-20
#@riga[:pa]=@riga[:pa]-20
#@riga[:ra]=@riga[:ra]-20
#@riga[:p]=18
#@riga[:pp]=18
#@riga[:rp]=18
#-----------------------------Attivate Misure Per Brema
#@attivabrema=true
#@bremaL=@riga[:pl]
#@bremaA=@riga[:pa]-20
#@bremaP=18



#-------------Le Ante Plana Non Hanno Telaio Che Può Fregare La Laccatura
#------------------------------------------------------------------------------------------------------Aggiunto 02.10.14
##Queste Ante Contengono La Variante Del Profilo Che Possono Creare Un Falso Laccato.
##521=009                                                                   (Profilo Laccato)
##502=003;502=004;502=006;502=009;502=1.102;502=1.104;502=3.302;502=4.402;  (Anta Laccata)
#if @tipo_elaborazione=="Logy"
#  var_antasc=@riga[:pvarianti].split(";")  #Considero le farianti del figlio (pannello anta)
#else
#  var_antasc=@riga[:var].split(";")
#end
#@islaccato=false   
#var_antasc.each{ |i| 
#  if ($stringa_laccati_scorrevoli.include? i) and (i.size>=6)   
#    @islaccato=true
#    break
#  end
#}
###puts "#{@riga[:descrizione]} #{@islaccato}"   #Visualizza Lo Stato Dei Pannelli

