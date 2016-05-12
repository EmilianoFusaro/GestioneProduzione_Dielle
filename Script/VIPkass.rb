#script per la modifica delle dimensioni della slip dei frontali cassetto TRENDY

if @riga[:codice]=="56016131" or @riga[:codice]=="56016133" or @riga[:codice]=="56016331" or @riga[:codice]=="56016333"
@riga[:a]=@riga[:a]-194
@riga[:pa]=@riga[:pa]-194
@riga[:ra]=@riga[:ra]-194

@riga[:p]=@riga[:p]-180
@riga[:pp]=@riga[:pp]-180
@riga[:rp]=@riga[:rp]-180
#puts "frontale cmd"

elsif  @riga[:codice]=="56046131" or @riga[:codice]=="56046133" or @riga[:codice]=="56046331" or @riga[:codice]=="56046333"
@riga[:a]=@riga[:a]-294
@riga[:pa]=@riga[:pa]-294
@riga[:ra]=@riga[:ra]-294

@riga[:p]=@riga[:p]-180
@riga[:pp]=@riga[:pp]-180
@riga[:rp]=@riga[:rp]-180
#puts "frontale cmo"

end