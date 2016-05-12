#---Attenzione Solo Con Elaborazione Union

@riga[:pcas]=@riga[:odima]  #setta profondità cassetto finita odima=dima originale non modificata 

varianti=riga[:var].split(";")
varianti.each{ |var| 
  if var.include? "404="     
    $maniglie_incasso.each{ |maniglia|  
	if TraduciVariante(var).to_s.downcase.include? maniglia
	  puts "Attenzione! Presenza Maniglia Incasso Forzo Ciclo"	  
      if @ciclost[0]=="1561"	     
	     @ciclost=@appo_ciclost
	     @ciclost[0]="1531"          #sostituisce il reparto di prelievo 
		 #@ciclost.insert(1,"4040")   #aggiunge all'interno dell'array --> modifica del 02/02/2015 Giuseppe le maniglia incasso "laguna" le lavora solo la Brema
		 @ciclost.insert(1,"4080")   #aggiunge all'interno dell'array 
		 RecuperaFasi(@ciclost)
		 @stampaslip=1
	  elsif @ciclost[0]=="1541"      
	     @ciclost=@appo_ciclost      #sostituisce il reparto di prelievo 
	  	 @ciclost[0]="1543"
		 RecuperaFasi(@ciclost)
		 @stampaslip=1
	  end 
	  break
	end
	}
	break
  end
}

