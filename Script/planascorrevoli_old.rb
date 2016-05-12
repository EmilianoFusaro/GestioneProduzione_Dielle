#Script per la produzione delle ante scorrevoli PLANA
load "K:/ecadpro/RubyLogy/funzioni.rb"


#Gestione delle fasce orizzontali
if @riga[:descrizione].include? "ANTA PLANA FASCIA ORIZZONTALE"
  #puts "fascia orizzontale"

	@riga[:pl]=@riga[:l]
	@riga[:pa]=@riga[:a]
	@riga[:pp]=@riga[:p]
	@riga[:rl]=@riga[:l]
	@riga[:ra]=@riga[:a]
	@riga[:rp]=@riga[:p]

	reset_fasi  #cancella tutte le fasi precedenti
	@fase1=Fase.new("1106","PREL.FASCE PLANA SCORR")
	@fase2=Fase.new("60","ASSEMBLAGGIO ANTE MODUS")

elsif @riga[:descrizione].include? "ANTA PLANA FASCIA VERTICALE"
  #puts "fascia orizzontale"

  @riga[:pl]=@riga[:l]
  @riga[:pa]=@riga[:a]
  @riga[:pp]=@riga[:p]
  @riga[:rl]=@riga[:l]
  @riga[:ra]=@riga[:a]
  @riga[:rp]=@riga[:p]

  reset_fasi  #cancella tutte le fasi precedenti
  @fase1=Fase.new("1106","PREL.FASCE PLANA SCORR")
  @fase2=Fase.new("60","ASSEMBLAGGIO ANTE MODUS")

elsif @riga[:descrizione].include? "ANTA PLANA PANNELLO"

  @riga[:pl]=@riga[:l]
  @riga[:pa]=@riga[:a]
  @riga[:pp]=@riga[:p]
  @riga[:rl]=@riga[:l]
  @riga[:ra]=@riga[:a]
  @riga[:rp]=@riga[:p]

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


