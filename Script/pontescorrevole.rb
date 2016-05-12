#Emiliano 05.05.15 Inverte La misura in funzione della vena del pannello

if @tipo_elaborazione=="Union"  

  if @riga[:note3].include?("VENA ORIZ") #solo con la vena orizzontale devo invertire le misure del pannello    
    #puts @riga
	
	if @riga[:dima]>@riga[:diml]
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
		
	#---Scambio misure anta su rordine di 3cad & Ecad che viene utilizzato dall'insider e x le bindelle
	Rordine.scambia_misure_vo(@riga[:numero],@riga[:riga])
	RordineEcad.scambia_misure_vo(@riga[:numero],@riga[:riga])
	
	#puts @riga
	
  end
  
end