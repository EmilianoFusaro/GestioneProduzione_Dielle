#puts @riga
if  @riga[:flag]=="M" and  (@ciclost.last=="90" or @ciclost.last=="10")
    #@ciclost.pop  #elimina ultimo valore array
	@ciclost[-1]="1"             #Forza il Montato
	RecuperaFasi(@ciclost)  #Riassegna Le Fasi Con Il Montato
end




