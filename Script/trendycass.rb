#script per la modifica delle dimensioni della slip dei frontali cassetto TRENDY

if @riga[:codice]=="56016131" or @riga[:codice]=="56016133" or @riga[:codice]=="56016331" or @riga[:codice]=="56016333"
@riga[:a]=@riga[:a]-189
@riga[:pa]=@riga[:pa]-189
@riga[:ra]=@riga[:ra]-189

@riga[:p]=@riga[:p]-180
@riga[:pp]=@riga[:pp]-180
@riga[:rp]=@riga[:rp]-180
#puts "frontale cmd"

#-----------------------------Attivate Misure Per Brema
@attivabrema=true
@bremaL=@riga[:pl]
@bremaA=@riga[:pa]
@bremaP=18

elsif  @riga[:codice]=="56046131" or @riga[:codice]=="56046133" or @riga[:codice]=="56046331" or @riga[:codice]=="56046333"
@riga[:a]=@riga[:a]-289
@riga[:pa]=@riga[:pa]-289
@riga[:ra]=@riga[:ra]-289

@riga[:p]=@riga[:p]-180
@riga[:pp]=@riga[:pp]-180
@riga[:rp]=@riga[:rp]-180
#puts "frontale cmo"

#-----------------------------Attivate Misure Per Brema
@attivabrema=true
@bremaL=@riga[:pl]
@bremaA=@riga[:pa]
@bremaP=18

end