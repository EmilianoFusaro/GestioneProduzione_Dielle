#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

def TrovaMagazzinoXLacc(riga,lista_magazzino)  #---Funzione Che In Base Ai Dati Determina il componente a magazzino da utilizzare
  
  islaccato=false

  variante=riga[:var].split(";")
  
  variante.each{ |i| 
  if ($stringa_laccati.include? i) and (i.size>=6)   #verificare se necessario i.size>=6
    islaccato=true
    break
  end
  }

  
  #olmonaturale (in caso di laccato olmo)
  #colore="OlmoNaturale"
  if islaccato==true    #TODO: gestire laccato olmo 
     # colore="Bianco"
     colore =riga[:laccodal]
     #puts colore #Bianco O Olmo Naturale
  elsif islaccato==false
      return nil #una riga non laccata in un carico laccato non deve essere considerata
  else
     colore=Colore.trova_strvaropz(riga[:var])
  end 

  
  #15.11.14 alcune righe di 3cad arrivano senza colore perchè sono solo bianche es. ante specchio 051083017
  if colore==nil
    puts "Attenzione Sto Forzando Questa Riga A Bianco Controllare Il Perche':"
	puts "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    puts riga	
	puts "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	colore="bianco"
	#File.open("TEST.txt", 'a') { |file| file.write("#{@riga}\n") }  #appende in un file di testo  x TEST      
  end
  
  #---esempio con array
  #condizione="f.#{colore.downcase}==true and f.dimx>=#{riga[:diml]} and f.dimy>=#{riga[:dima]} and dimz=#{riga[:dimp]}"
  #puts condizione
  #ciclo=lista_magazzino.select{|f| eval(condizione)}
  #puts ciclo.count 

  trovato=false
  fm_lunghezza=""
  fm_profondita=""
  tipologia=""

  #------------------------------------------cerco misure diverse dal padre originale es. cassetto  
  if  riga[:orientamento]=="LAP"
    dim_x=riga[:diml] #+riga[:xtolleranza]
    dim_y=riga[:dima] #+riga[:ytolleranza]
    dim_z=riga[:dimp]
    adim_x=riga[:adiml]
    adim_y=riga[:adima]
    adim_z=riga[:adimp]
  elsif riga[:orientamento]=="LPA"
    dim_x=riga[:diml] #+riga[:xtolleranza]
    dim_y=riga[:dimp] #+riga[:ytolleranza]
    dim_z=riga[:dima]
    adim_x=riga[:adiml]
    adim_y=riga[:adimp]
    adim_z=riga[:adima]
  elsif riga[:orientamento]=="ALP"
    dim_x=riga[:dima] #+riga[:xtolleranza]
    dim_y=riga[:diml] #+riga[:ytolleranza]
    dim_z=riga[:dimp]
    adim_x=riga[:adima]
    adim_y=riga[:adiml]
    adim_z=riga[:adimp]
  elsif riga[:orientamento]=="APL"    
    dim_x=riga[:dima] #+riga[:xtolleranza]
    dim_y=riga[:dimp] #+riga[:ytolleranza]
    dim_z=riga[:diml]
    adim_x=riga[:adima]
    adim_y=riga[:adimp]
    adim_z=riga[:adiml]
  elsif riga[:orientamento]=="PAL"    
    dim_x=riga[:dimp] #+riga[:xtolleranza]
    dim_y=riga[:dima] #+riga[:ytolleranza]
    dim_z=riga[:diml]
    adim_x=riga[:adimp]
    adim_y=riga[:adima]
    adim_z=riga[:adiml]
  elsif riga[:orientamento]=="PLA"    
    dim_x=riga[:dimp] #+riga[:xtolleranza]
    dim_y=riga[:diml] #+riga[:ytolleranza]
    dim_z=riga[:dima]
    adim_x=riga[:adimp]
    adim_y=riga[:adiml]
    adim_z=riga[:adima]
  else
    puts "----ERRORRE ORIENTAMENTO----"
    dim_x=riga[:diml] #+riga[:xtolleranza]
    dim_y=riga[:dima] #+riga[:ytolleranza]
    dim_z=riga[:dimp]  
    adim_x=riga[:adiml]
    adim_y=riga[:adima]
    adim_z=riga[:adimp]  
  end  

  if riga[:xpannello]>0
   dim_x=riga[:xpannello]
  end
  if riga[:ypannello]>0
   dim_y=riga[:ypannello] 
  end
  if riga[:zpannello]>0
   dim_z=riga[:zpannello]    
  end

  riga[:diml]=dim_x
  riga[:dima]=dim_y
  riga[:dimp]=dim_z

  riga[:adiml]=adim_x
  riga[:adima]=adim_y
  riga[:adimp]=adim_z

    
   if riga[:ciclofisso]==true   #il ciclo viene forzato senza nessun controllo magazzino

     tipologia="PANNELLO"
     #Creazione Hash Fittizio Chiave,Valore
     r_mag = { :codice      =>riga[:codart],    
               :descrizione =>riga[:des],
               :dimx        =>riga[:diml],
               :dimy        =>riga[:dima],
               :dimz        =>riga[:dimp],
               :tipologia   =>tipologia,
               :bianco           =>true,
               :larice           =>true,
               :roverenaturale   =>true,
               :corda            =>true,
               :roveretabacco    =>true,
               :olmoperla        =>true,
               :olmonaturale     =>true,
               :olmolava         =>true,
               :mandarino        =>true,
               :girasole         =>true,              
               :magnolia         =>true,                            
               :alabastro        =>true,                                          
               :avio             =>true,
               :verdeprimavera   =>true,
               :glicine          =>true,
               :acero            =>true,
               :punto            =>true,
               :riga             =>true,                                           
               :acxbianco        =>true,                                                         
               :acxtortora       =>true,                                                                       
               :moro             =>true,                                                                                     
               :cenere           =>true,                                                                                     
               :famiglia         =>"PANNELLO"                                                                                               
            }     
     riga_magazzino=r_mag
     #puts riga_magazzino
     ciclo_magazzino=CicloMagazzino.new(riga,riga_magazzino,fm_lunghezza,fm_profondita,islaccato,tipologia)
     return ciclo_magazzino     
   end  

  
  #------------------------------------------Se Richiesto inverte l'ordine di ordinamento
  ordina_per="dimx,dimy"
  if riga[:ordinecerca]!=nil
    if riga[:ordinecerca][0]=="Y" 
      ordina_per="dimy,dimx"
      puts "Ordinamento Magazzino Inverito"
    end
  end


  #---------------------------------------------------------------------CONTROLLO NORMALE
  riga[:famiglie].split(";").each{|famiglia| 

   #puts "#{dim_x} - #{dim_y} totale  #{dim_x+riga[:xtolleranza]}"


   #sql_condizione="select top 1 * from magazzino where famiglia='#{famiglia}' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+riga[:xtolleranza]} and DimY>=#{dim_y+riga[:ytolleranza]} order by dimx,dimy"
   sql_condizione="select top 1 * from magazzino where famiglia='#{famiglia}' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+riga[:xtolleranza]} and DimY>=#{dim_y+riga[:ytolleranza]} order by #{ordina_per}"
   #puts sql_condizione
   #puts sql_condizione 
   #puts Magazzino.with_sql(sql_condizione).single_value  #capire come funziona
   #Magazzino.with_sql(sql_condizione).select
   #Magazzino.with_sql(sql_condizione).select.all
   #gino=Magazzino.with_sql(sql_condizione).select.all

   riga_magazzino=nil

   DB_ECAD.fetch(sql_condizione) do |r_mag|
    #puts r_mag 
    trovato=true
    tipologia="MAGAZZINO"
    if riga[:semprefm]==true
      tipologia="MAGAZZINOFM"   #Alcuni Elementi Devono Essere Forzati  a FM (fianchi obliqui)
    end
    riga_magazzino=r_mag    
    if r_mag[:dimx]>(dim_x+riga[:xtolleranza])
        fm_lunghezza="FM"
        tipologia="MAGAZZINOFM"
    end 
    if r_mag[:dimy]>(dim_y+riga[:ytolleranza])
        fm_profondita="FM"
        tipologia="MAGAZZINOFM"
    end       
   end   
 
   #------------------------------------------Gestione Tolleranza Solo Su FM (Se Presete ripeto la ricerca)
   if tipologia=="MAGAZZINOFM" and riga[:xtolleranzafm]!=nil and riga[:ytolleranzafm]!=nil

    if riga[:xtolleranzafm]!=0 or riga[:ytolleranzafm]!=0
      puts "ATTENZIONE ENTRO IN TOLLERANZA FM"
      xtolleranzafm=riga[:xtolleranzafm]
      ytolleranzafm=riga[:ytolleranzafm]
      if (riga[:diml]==riga[:adiml]) and (fm_lunghezza=="")  #non ho fuori misura in questo lato e  quindi annullo tolleranza fm (riga mi indica fm su rubycomponentix fm_lunghezza potrebbe essere padre diverso da figlio)
        xtolleranzafm=0
      else
        puts "Tolleranza su fuori misura in X"
      end
      if (riga[:dima]==riga[:adima]) and (fm_profondita=="") #non ho fuori misura in questo lato e  quindi annullo tolleranza fm
        ytolleranzafm=0
      else
        puts "Tolleranza su fuori misura in Y"
      end
      sql_condizione="select top 1 * from magazzino where famiglia='#{famiglia}' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+xtolleranzafm} and DimY>=#{dim_y+ytolleranzafm} order by #{ordina_per}"
      #puts sql_condizione
      trovato=false
      riga_magazzino=nil

      DB_ECAD.fetch(sql_condizione) do |r_mag|
        #puts r_mag 
        trovato=true
        tipologia="MAGAZZINOFM"
        riga_magazzino=r_mag    
        if r_mag[:dimx]>(dim_x+xtolleranzafm)
          fm_lunghezza="FM"
          tipologia="MAGAZZINOFM"
        end 
        if r_mag[:dimy]>(dim_y+ytolleranzafm)
          fm_profondita="FM"
          tipologia="MAGAZZINOFM"
        end       
      end
    
    end

   end
   
   #puts "#{riga_magazzino} Magazzino" #x debug
   if trovato==true #se presente in una famiglia interrompo la ricerca
    ciclo_magazzino=CicloMagazzino.new(riga,riga_magazzino,fm_lunghezza,fm_profondita,islaccato,tipologia)
    return ciclo_magazzino
    break
   end

   }

  tipologia=""
   #---------------------------------------------------------------------CONTROLLO DA BARRA 
   #sql_condizione="select top 1 * from magazzino where famiglia='BARRA' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+riga[:xtolleranza]} and DimY>=#{dim_y+riga[:ytolleranza]} order by dimx,dimy"
   sql_condizione="select top 1 * from magazzino where famiglia='BARRA' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+riga[:xtolleranza]} and DimY>=#{dim_y+riga[:ytolleranza]} order by #{ordina_per}"

   riga_magazzino=nil

   DB_ECAD.fetch(sql_condizione) do |r_mag|
    #puts r_mag 
    trovato=true
    tipologia="BARRA"
    riga_magazzino=r_mag    
    if r_mag[:dimx]>(dim_x+riga[:xtolleranza])
        fm_lunghezza="FM"
        tipologia="BARRAFM"
    end 
    if r_mag[:dimy]>(dim_y+riga[:ytolleranza])
        fm_profondita="FM"
        tipologia="BARRAFM"
    end       
   end   
   
   #puts "#{riga_magazzino} Barra" #x debug

   if trovato==true #se presente nelle barre interrompo la ricerca
    ciclo_magazzino=CicloMagazzino.new(riga,riga_magazzino,fm_lunghezza,fm_profondita,islaccato,tipologia)
    return ciclo_magazzino
   end 

   #---------------------------------------------------------------------CONTROLLO DA PANNELLO
   #sql_condizione="select top 1 * from magazzino where famiglia='PANNELLO' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+riga[:xtolleranza]} and DimY>=#{dim_y+riga[:ytolleranza]} order by dimx,dimy"
   sql_condizione="select top 1 * from magazzino where famiglia='PANNELLO' and #{colore.downcase}=1 and DimZ=#{dim_z} and DimX>=#{dim_x+riga[:xtolleranza]} and DimY>=#{dim_y+riga[:ytolleranza]} order by #{ordina_per}"

   riga_magazzino=nil

   DB_ECAD.fetch(sql_condizione) do |r_mag|
    trovato=true
    tipologia="PANNELLO"
    riga_magazzino=r_mag 
    fm_lunghezza="FM"
    fm_profondita="FM"
   end   
   
   #puts "#{riga_magazzino} Pannello" #x debug

   if trovato==true #se presente nelle barre interrompo la ricerca
    ciclo_magazzino=CicloMagazzino.new(riga,riga_magazzino,fm_lunghezza,fm_profondita,islaccato,tipologia)
    return ciclo_magazzino    
   end 

  #---------------------------------------------------------------------QUALCOSA NON FUNZIONA NELLA RICERCA
   puts "Magazzino Non Trovato"
   puts riga
   return nil
   
   #if trovato==true  
   #  puts "Elemento Presente A Magazzino #{fm_lunghezza} #{fm_profondita}"
   #else
   #  puts "Elemento Non Presente A Magazzino"
   #end

end


