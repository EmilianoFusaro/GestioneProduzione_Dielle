#puts @riga[:descrizione]

if @riga[:descrizione].include? "PANNELLO ANTA"  #il pannello delle ante kristal è sempre bianco
  @ciclost=@appo_ciclost  
  @islaccato=false  
  RecuperaFasi(@ciclost)
  #la larghezza delle ante kristal devono generare un pannello 4 mm più corto
  @riga[:a]=@riga[:a]-4
  @riga[:pa]=@riga[:pa]-4
  @riga[:ra]=@riga[:ra]-4
  #lo spessore del pannello è di 18 mm
  @riga[:p]=18
  @riga[:pp]=18
  @riga[:rp]=18
elsif @riga[:descrizione].include? "VETRO KRISTAL"  #il vetro viene laccato 
  #l'altezza del vetro kristal deve essere 1 mm più corto
  @riga[:l]=@riga[:l]-1
  @riga[:pl]=@riga[:pl]-1
  @riga[:rl]=@riga[:rl]-1
  #la larghezza del vetro kristal deve essere 5 mm più corto
  @riga[:a]=@riga[:a]-5
  @riga[:pa]=@riga[:pa]-5
  @riga[:ra]=@riga[:ra]-5
  #lo spessore del vetro è di 4 mm
  @riga[:p]=4
  @riga[:pp]=4
  @riga[:rp]=4
end

