#script per la modifica delle dimensioni della slip dei frontali cassettone CARGO

if @riga[:codice]=="56046221" or @riga[:codice]=="56046421"
@riga[:a]=@riga[:a]-212
@riga[:pa]=@riga[:pa]-212
@riga[:ra]=@riga[:ra]-212

@riga[:p]=@riga[:p]-238
@riga[:pp]=@riga[:pp]-238
@riga[:rp]=@riga[:rp]-238
#puts "frontale cassettone piccolo"

elsif @riga[:codice]=="56046211" or @riga[:codice]=="56046411"
@riga[:a]=@riga[:a]-212
@riga[:pa]=@riga[:pa]-212
@riga[:ra]=@riga[:ra]-212

@riga[:p]=@riga[:p]-238
@riga[:pp]=@riga[:pp]-238
@riga[:rp]=@riga[:rp]-238
#puts "frontale cassettone grande"

end