#script per la modifica delle dimensioni della slip dei frontali cassetto SQUARE

lista_codici_a="56018131;56018133;56018331;56018333;56018141;56018143;56018341;56018343;56018151;56018153;56018351;56018353;"
lista_codici_b="56048131;56048133;56048331;56048333;56048141;56048143;56048341;56048343;56048151;56048153;56048351;56048353;"

if (lista_codici_a.include? @riga[:codice])==true
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

elsif (lista_codici_b.include? @riga[:codice])==true
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