#Creato 02/11/15 Emiliano-Michael x gestire eccezione fianchi pensile angolo
if  @riga[:flag]!="M"
    puts "Smontato Forzo Reparto 51 Brema Vip"
    #@ciclost.pop  #elimina ultimo valore array
	@ciclost[-1]="51"             #Forza Nil
	@ciclost[-2]="51"             #Forza Brema Vip Smontato	
	
	#@ciclost=@ciclost[0...-1]     #accorcio la lista cicli
	#@ciclost[-1]="51"             #Forza Nil
	
	#@ciclost[-2]="51"             #Forza Brema Vip Smontato	
	#@ciclost.pop                  #accorcio la lista cicli
	
	RecuperaFasi(@ciclost)  #Riassegna Le Fasi Con Il Reparto Brema Vip
end

#Nota : Al momento questo script crea una riga "Brema Vip" in più vedere come eliminarla




