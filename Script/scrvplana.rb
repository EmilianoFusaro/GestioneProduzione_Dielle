#script per la modifica delle dimensioni della slip dei frontali contenitori laterali CARGO

lista_codici_a="52285551;52285561;52285571;52285581"
lista_codici_b="52285601;52285611;52285621"
lista_codici_c="56026353;56016353;56016351;56026351;56026153;56016153;56016151;56026151"

if @riga[:codice].include? lista_codici_a

@riga[:l]=@riga[:l]-105
@riga[:pl]=@riga[:pl]-105
@riga[:rl]=@riga[:rl]-105

@riga[:a]=@riga[:a]-105
@riga[:pa]=@riga[:pa]-105
@riga[:ra]=@riga[:ra]-105

@riga[:p]=@riga[:p]-345
@riga[:pp]=@riga[:pp]-345
@riga[:rp]=@riga[:rp]-345
#puts "fascia orizzontale"

elsif @riga[:codice].include? lista_codici_b

@riga[:l]=@riga[:l]-105
@riga[:pl]=@riga[:pl]-105
@riga[:rl]=@riga[:rl]-105

@riga[:a]=@riga[:a]-311
@riga[:pa]=@riga[:pa]-311
@riga[:ra]=@riga[:ra]-311

@riga[:p]=@riga[:p]-139
@riga[:pp]=@riga[:pp]-139
@riga[:rp]=@riga[:rp]-139
#puts "fascia verticale"

end