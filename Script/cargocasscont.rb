#script per la modifica delle dimensioni della slip dei frontali contenitori laterali CARGO

lista_codici_a="56026443;56016443;56026441;56016441;56026243;56016243;56016241;56026241"
lista_codici_b="56026343;56016343;56016341;56026341;56026143;56016143;56016141;56026141"
lista_codici_c="56026353;56016353;56016351;56026351;56026153;56016153;56016151;56026151"

if @riga[:codice].include? lista_codici_a

@riga[:a]=@riga[:a]-105
@riga[:pa]=@riga[:pa]-105
@riga[:ra]=@riga[:ra]-105

@riga[:p]=@riga[:p]-345
@riga[:pp]=@riga[:pp]-345
@riga[:rp]=@riga[:rp]-345
#puts "frontale cassettone H363"

elsif @riga[:codice].include? lista_codici_b

@riga[:a]=@riga[:a]-311
@riga[:pa]=@riga[:pa]-311
@riga[:ra]=@riga[:ra]-311

@riga[:p]=@riga[:p]-139
@riga[:pp]=@riga[:pp]-139
@riga[:rp]=@riga[:rp]-139
#puts "frontale cassetto H157"

elsif @riga[:codice].include? lista_codici_c

@riga[:a]=@riga[:a]-265
@riga[:pa]=@riga[:pa]-265
@riga[:ra]=@riga[:ra]-265

@riga[:p]=@riga[:p]-185
@riga[:pp]=@riga[:pp]-185
@riga[:rp]=@riga[:rp]-185
#puts "frontale cassetto H203"

end