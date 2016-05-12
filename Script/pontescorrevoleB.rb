#Emiliano 05.05.15 Inverte La misura in funzione della vena del pannello

if @tipo_elaborazione=="Union"  

  if @riga[:note3].include?("VENA ORIZ") #solo con la vena orizzontale devo invertire le misure del pannello    
    #puts @riga
    #puts @riga[:codart]
	#puts "enter"
	
	if @riga[:dima]>@riga[:diml]   #evito che arriva invertita da rordine per una precedente elaborazione
	  puts "Giro Le Misure"
      riga_appo=@riga[:diml]
	  @riga[:diml]=@riga[:dima]
	  @riga[:dima]=riga_appo
 	  #-----------------------	
	  riga_appo=@ciclo.riga_magazzino[:dimx]
	  @ciclo.riga_magazzino[:dimx]=@ciclo.riga_magazzino[:dimy]
	  @ciclo.riga_magazzino[:dimy]=riga_appo
	end
  
    a_des=@riga[:des].upcase.split("X")
    if a_des.size>2               #inverto le misure in descrizion	e
      b_des=a_des[0].split(" ")
      appo=b_des[-1]
      b_des[-1]=a_des[1]
      a_des[1]=appo
      @riga[:des]=b_des.join(" ") + "X" + a_des[1..-1].join("X")    #join concatena articolo & [1..-1] estrae dall'array 1 sino alla fine della matrice
    else  
      puts "Attenzione Descrizione Non Conforme Al Tipo Di Elaborazione"  
    end
  
    #-----------------------------------------------------------------------
    
    a_des=@ciclo.riga_magazzino[:descrizione].upcase.split("X")  
    if a_des.size>2               #inverto le misure in descrizion	e
      b_des=a_des[0].split(" ")
      appo=b_des[-1]
      b_des[-1]=a_des[1]
      a_des[1]=appo
      @ciclo.riga_magazzino[:descrizione]=b_des.join(" ") + "X" + a_des[1..-1].join("X")    
    else  
      puts "Attenzione Descrizione Non Conforme Al Tipo Di Elaborazione"  
    end
	
	#con vena orizzonatale cambia il ciclo di bordatura
	#@riga[:dapannello].gsub!("3024","3004")  #replace string (con ! riassegna il nuovo valore)
	#@ciclost[2]="3004"
	#--Modifiato 29.05.15 (Giuseppe - Michael)
	#@fase3.codice="3004"
	#@fase3.descrizione="*IMA 14 / 14 / 05  /  14"
	#puts @fase3.codice
	@fase3.codice="3009"
	@fase3.descrizione="*IMA 05 / 14 / 05  /  14"
	
	#---Scambio misure anta su rordine di 3cad & Ecad che viene utilizzato dall'insider e x le bindelle
	Rordine.scambia_misure_vo(@riga[:numero],@riga[:riga])
	RordineEcad.scambia_misure_vo(@riga[:numero],@riga[:riga])
	
	#puts @riga
	#puts @riga[:dapannello]
	
  end
  
end