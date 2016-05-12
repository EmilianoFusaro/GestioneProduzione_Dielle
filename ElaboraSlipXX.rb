class Slip 

attr_accessor :riga,:conta
attr_accessor :ciclost,:ciclofm
attr_accessor :fase1,:fase2,:fase3,:fase4,:fase5,:fase6,:fase7,:fase8,:fase9
attr_accessor :stampaslip
attr_accessor :islaccato
attr_accessor :script
attr_accessor :attivabrema,:bremaL,:bremaA,:bremaP   #Permette Di Generare Dimensioni Diverse Solo X La Brema
#attr_accessor :salvaslip #abilitare per gestire salta slip

	def DatiCarico(xriga,ciclo,islaccato,conta_slip)
        @conta=conta_slip 
        @riga=xriga              
        @fase1,@fase2,@fase3,@fase4,@fase5,@fase6,@fase7,@fase8,@fase9=nil
        @stampaslip=0
        @script=""
        @tipo_elaborazione="Logy"
        @riga[:pcas]=0     #---setta dimensione default profondità cassetto
        #@salvaslip=true   #---inizialmente settata su sempre vera #abilitare per gestire salta slip

        #--------------------------------Setta Variabili Di Default x Brema
        @attivabrema=false
        @bremaL=0
        @bremaA=0
        @bremaP=0

        #Gestire Controllo Fuori Misura & Very
        #in ECAD viene riempita FM & PFM
        #in ECAD viene riempita solo PFM quindi faccio riferimento solo a quella

        if ciclo[0].verifdist==true               #----Verifica Controllo Forzato FM  (Attenzione Sui Cassetti-Cassettoni verifdist dovrebbe essere false)
           if (@riga[:l] != @riga[:pl]) or (@riga[:a] != @riga[:pa]) or (@riga[:p] != @riga[:pp])
            @riga[:pfm]="FM"
           end
        end 

        #@riga[:fm].count("X") Conteggia il numero di X nella stringa
        #if @riga[:fm]!="FM" and not (@riga[:fm].include? "X")==false  #Standard (inclusione darebbe true e la condi)
        #3cad fm ecad X__
        if @riga[:pfm]!="FM" and (@riga[:pfm].include?("X")==false) #Standard (inclusione darebbe true e la condizione deve essere falsa ma vera nell'if)
            #puts "Standard"
            @ciclost=ciclo[0].ciclost.split            
            if ciclo[0].very.split()[0]=="1"   #----Verifica Se Stampare La Slip Standard
              @stampaslip=1
            end                        
        else                    #FM  
            #puts "FM"
            @ciclost=ciclo[0].ciclofm.split
            if ciclo[0].very.split()[1]=="1"   #----Verifica Se Stampare La Slip FM
              @stampaslip=1
            end
        end  

        #----Aggiunta Forzatura Montato 16.10.14 disattivato script montato x velocità
        #if  @riga[:flag]=="M" and  (@ciclost.last=="90" or @ciclost.last=="10" or @ciclost.last=="5")
        #  #@ciclost.pop  #elimina ultimo valore array
        #  @ciclost[-1]="1"             #Forza il Montato        
        #end
        #----------Qualsiasi Classe Etichetta Diventa Montato 31.10.14
        #begin
        if  @riga[:flag]=="M"
          ultima_fase=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[-1]}"} #Deterimino L'ultima Fase
          if  ultima_fase!=nil and ultima_fase.tiporeparto=="Etichetta"
            @ciclost[-1]="1"             #Forza il Montato        
          end 
        end
        #rescue Exception => msg 
        #  puts "#{msg}  #{@riga[:pcod]} #{@riga[:numero]}"
        #end  
        #------------------------------------------------

        @islaccato=islaccato

        @appo_ciclost=@ciclost.dup           #memorizzo ciclo prima di passare al recupero fasi (dup copia x valore non per riferimento)
                      
        RecuperaFasi(@ciclost)
        
        #attenzione arriva 0 o 1      
        if ciclo[0].abilitascript==true     #rielabora la slip con uno script se esistente          
         PreProcessaSlip(ciclo)
        end      

        if @islaccato==true              #se laccato forza la stampa delle slip
         @stampaslip=1
        end  
             
        #if @salvaslip==true  #serve per gestire alcuni casi limite #abilitare per gestire salta slip
          SalvaSlip()
        #end
  end


  def RecuperaFasi(lista_fasi)
  
    if @islaccato==true
      #puts "---------------PRIMA"
      #puts @ciclost
      ultima_fase=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[-1]}"} #Deterimino L'ultima Fase
      
      if ultima_fase!=nil and ultima_fase.tiporeparto=="Etichetta"
        @ciclost[-1]="84"
      else        
        @ciclost.push("84")             #Attenzione Aggiunto 15.10.14 Per Gestire Casi Limite Laccato (se non trovo un etichetta finale aggiungo alla fine 84)
      end

      @ciclost=@ciclost - ["98","99"]  #elimino fasi sparse di laccatura        
      

      #if @ciclost[-1]==98 or @ciclost[-1]==99 #se l'ultima fase corrisponde ad una fase laccata la sostituisco con fase 84
      #  @ciclost[-1]=84
      #end      
      #puts "---------------DOPO"
      #puts @ciclost
    #else
    #  puts "NON LACCATO"
    
    end


    contacicli=lista_fasi.count    

    if contacicli>0          
      @fase1=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[0]}"}    #Attenzione Se Non Trova Genera Eccezione (se trova ritorna un hash se non trova nil)
    end
    if contacicli>1
      @fase2=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[1]}"}
    end
    if contacicli>2
      @fase3=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[2]}"}
    end
    if contacicli>3
      @fase4=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[3]}"}
    end
    if contacicli>4
      @fase5=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[4]}"}
    end
    if contacicli>5
      @fase6=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[5]}"}
    end
    if contacicli>6
      @fase7=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[6]}"}
    end
    if contacicli>7
      @fase8=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[7]}"}
    end
    if contacicli>8
      @fase9=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[8]}"}
    end
  end


    def SalvaSlip()

      tempslip=TempSlip.new
      tempslip.id=@conta
      tempslip.carico=@riga[:carico]
      tempslip.numero=@riga[:numero]
      tempslip.matricola=@riga[:matricola]
      tempslip.scarico=@riga[:scarico]
      tempslip.codice=@riga[:codice]
      tempslip.descrizione=@riga[:descrizione]
      tempslip.desc2=@riga[:desc2]
      tempslip.qta=@riga[:qta]
      tempslip.l=@riga[:l]
      tempslip.a=@riga[:a]
      tempslip.p=@riga[:p]
      tempslip.rl=@riga[:rl]
      tempslip.ra=@riga[:ra]
      tempslip.rp=@riga[:rp]
      tempslip.pcas=@riga[:pcas]
      if @riga[:pfm].include?("X")
        @riga[:pfm]="FM"
      end
      tempslip.fm=@riga[:pfm]
      tempslip.eti=@riga[:eti]
      tempslip.pcod=@riga[:pcod]
      tempslip.pdes=@riga[:pdes]
      tempslip.pl=@riga[:pl]
      tempslip.pa=@riga[:pa]
      tempslip.pp=@riga[:pp]
      tempslip.pfm=@riga[:pfm]    #verificare cosa mettere
      tempslip.idp=0               #verificare cosa mettere
      tempslip.stampaslip=@stampaslip
      tempslip.ciclo=@riga[:ciclo]
      tempslip.imballo=@riga[:imballo]
      tempslip.flag=@riga[:flag]
      #tempslip.islaccato=@islaccato    #spostato perchè in fase di traduzione può cambiare
      tempslip.pxlavdx=@riga[:pxlavdx]
      tempslip.pxlavsx=@riga[:pxlavsx]
      tempslip.riga=@riga[:riga]
      tempslip.script=@script
      tempslip.percorso=@riga[:percorso]
      #-----------------------------------------------------------------Campi X Lavorazioni Brema
      tempslip.attivabrema=@attivabrema
      tempslip.bremal=@bremaL
      tempslip.bremaa=@bremaA    
      tempslip.bremap=@bremaP
      #----------------------------------------------------------------Aggiunta Note
      tempslip.nota1=@riga[:note1]
      tempslip.nota2=@riga[:note2]
      tempslip.nota3=@riga[:note3]
      tempslip.nota4=@riga[:note4]
      #Aggiunto 24.02.2015 per evitare note doppie
      if @riga[:note5].to_s==@riga[:rnote5].to_s
        tempslip.nota5=@riga[:note5].to_s
      else    
        tempslip.nota5=@riga[:note5].to_s+@riga[:rnote5].to_s  #caricocomp 3cad non porta la nota5 di rordine
      end 
      tempslip.nota6=@riga[:note6]
      #----------------------------------------------------------------Aggiunta Note
      #-----------------------------------------------------------------differenziato se ciclo fm o Standard    
      if @fase1 != nil
        tempslip.c1=@fase1.codice
        tempslip.dc1=@fase1.descrizione
      end  

      if @fase2 != nil        
        tempslip.c2=@fase2.codice
        tempslip.dc2=@fase2.descrizione         
      end

      if @fase3 != nil        
        tempslip.c3=@fase3.codice
        tempslip.dc3=@fase3.descrizione
      end 
 
      if @fase4 != nil
        tempslip.c4=@fase4.codice
        tempslip.dc4=@fase4.descrizione 
      end  

      if @fase5 != nil
        tempslip.c5=@fase5.codice
        tempslip.dc5=@fase5.descrizione
      end

      if @fase6 != nil
        tempslip.c6=@fase6.codice
        tempslip.dc6=@fase6.descrizione
      end

      if @fase7 != nil
        tempslip.c7=@fase7.codice
        tempslip.dc7=@fase7.descrizione
      end

      if @fase8 != nil
        tempslip.c8=@fase8.codice
        tempslip.dc8=@fase8.descrizione
      end  

      if @fase9 != nil
        tempslip.c9=@fase9.codice
        tempslip.dc9=@fase9.descrizione
      end

      #----------------------------------------------------------------Inserimento Varianti Figlio (if in linea rallenta di circa 5 secondi l'elaborazione)
      var=@riga[:varianti].split(";")
     
      if var.count>=1
        #puts var[0]
        tempslip.v1=var[0].split('=')[0] + " = " + TraduciVariante(var[0]) if var[0].size>2
      end
      if var.count>=2
         #puts var[1]        
         tempslip.v2=var[1].split('=')[0] + " = " + TraduciVariante(var[1])  if var[1].size>2
      end
      if var.count>=3 
         tempslip.v3=var[2].split('=')[0] + " = " + TraduciVariante(var[2])  if var[2].size>2
      end
      if var.count>=4
         tempslip.v4=var[3].split('=')[0] + " = " + TraduciVariante(var[3])  if var[3].size>2
      end
      if var.count>=5
         tempslip.v5=var[4].split('=')[0] + " = " + TraduciVariante(var[4])  if var[4].size>2
      end
      if var.count>=6
         tempslip.v6=var[5].split('=')[0] + " = " + TraduciVariante(var[5])  if var[5].size>2
      end

      #----------------------------------------------------------------Inserimento Varianti Padre
      var=@riga[:pvarianti].split(";")
     
      if var.count>=1
         tempslip.pv1=var[0].split('=')[0] + " = " + TraduciVariante(var[0])  if var[0].size>2
      end
      if var.count>=2
         tempslip.pv2=var[1].split('=')[0] + " = " + TraduciVariante(var[1])  if var[1].size>2
      end
      if var.count>=3
         tempslip.pv3=var[2].split('=')[0] + " = " + TraduciVariante(var[2])  if var[2].size>2
      end
      if var.count>=4
         tempslip.pv4=var[3].split('=')[0] + " = " + TraduciVariante(var[3])  if var[3].size>2
      end
      if var.count>=5
         tempslip.pv5=var[4].split('=')[0] + " = " + TraduciVariante(var[4])  if var[4].size>2
      end
      if var.count>=6
         tempslip.pv6=var[5].split('=')[0] + " = " + TraduciVariante(var[5])  if var[5].size>2
      end                  
      #tempslip.barcode="X.#{@riga[:numero]}.#{@riga[:eti]}"
	    tempslip.barcode="X.#{@riga[:numero]}.#{@riga[:matricola]}"
      tempslip.tipoelaborazione="Logy" 
      tempslip.cliente=riga[:cliente]
      tempslip.var3cadrordine=riga[:pvarianti]  #salva la lista di varianti del padre in caricocomp-rordine

      tempslip.islaccato=@islaccato    #spostato perchè in fase di traduzione può cambiare

      tempslip.anticipo=Anticipi.cerca(@riga[:pcod]) #Al Monento Non Abilitato In 3Cad

      tempslip.save
    end


  def TraduciVariante(stringavariante)

    #------Sistema A Memoria (Più efficente con server sql poco performante)
    appo_var=$lista_varianti.select{|f| f.codvar=="#{stringavariante.split('=')[0]}" and f.codopz=="#{stringavariante.split("=")[1]}"}
    if appo_var.count==1        

        #ATTENZIONE IN FASE DI PROVA -- EVENTUALMENTE DIFFERENZIARE LA DESCRIZIONE CON CARATTERE SPECIALE 13.10.14
        if @islaccato==true and (appo_var[0].des.downcase.include?("punto")==true or appo_var[0].des.downcase.include?("riga")==true)
         @islaccato=false
         puts "Modifico Texture Da Laccato A Normale"
         #File.open("TEST.txt", 'a') { |file| file.write("#{@riga}\n") }  #appende in un file di testo  x TEST      
        end

        return appo_var[0].des
    else      
        return ""
    end 
  end

  def PreProcessaSlip(ciclo)
    begin
      puts "Elaboro Script #{ciclo[0].script}"
      #script = IO.read("K:/Ecadpro/RubyLogy/script/#{ciclo[0].script}")
      script = IO.read("K:/Ecadpro/RubyLogyUnion/script/#{ciclo[0].script}")
      eval(script)
      @script=ciclo[0].script + "-ok"
    rescue SyntaxError => se      ##Intercetta Errori Di Sintassi
     puts "Riscontrati Errori Script Ciclo cod:#{ciclo[0].cod} padre:#{ciclo[0].padre} codbarra:#{ciclo[0].padre} variante:#{ciclo[0].variante} laccato#{ciclo[0].laccato}" 
     @script=ciclo[0].script + "-errore"
    end
  end

end


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


class SlipUnion 
attr_accessor :ciclo
attr_accessor :riga,:conta
attr_accessor :ciclost,:appo_ciclost
attr_accessor :fase1,:fase2,:fase3,:fase4,:fase5,:fase6,:fase7,:fase8,:fase9
attr_accessor :stampaslip
attr_accessor :islaccato
attr_accessor :script
attr_accessor :attivabrema,:bremaL,:bremaA,:bremaP   #Permette Di Generare Dimensioni Diverse Solo X La Brema
#attr_accessor :salvaslip #abilitare per gestire salta slip

  def DatiCarico(ciclo,conta_slip,carico)
        @conta=conta_slip
        @ciclo=ciclo
        @riga=@ciclo.riga              
        @fase1,@fase2,@fase3,@fase4,@fase5,@fase6,@fase7,@fase8,@fase9=nil
        @stampaslip=0
        @script=""
        @carico=carico   #Distinguo Tra Carico & Commessa
        @tipo_elaborazione="Union"
        @riga[:pcas]=0     #---setta dimensione default profondità cassetto

        #gino=STDIN.gets.chomp() #stoppare
        #@salvaslip=true   #---inizialmente settata su sempre vera #abilitare per gestire salta slip

        #--------------------------------Setta Variabili Di Default x Brema
        @attivabrema=false
        @bremaL=0
        @bremaA=0
        @bremaP=0

        #Gestire Controllo Fuori Misura & Very
        #in ECAD viene riempita FM & PFM
        #in ECAD viene riempita solo PFM quindi faccio riferimento solo a quella        

        if @ciclo.tipologia=="MAGAZZINO"
          if @riga[:stampamagazzino]==true
            @stampaslip=1
          end          
          @ciclost=@riga[:magazzino].split(";")
        elsif @ciclo.tipologia=="MAGAZZINOFM"
          #@riga[:pfm]="FM"
          @stampaslip=1
          @ciclost=@riga[:magazzinofm].split(";")
        elsif @ciclo.tipologia=="BARRA" or  @ciclo.tipologia=="BARRAFM"
          #@riga[:pfm]="FM"
          @stampaslip=1
          @ciclost=@riga[:dabarra].split(";")
        else  #---DA PANNELLO
          #@riga[:pfm]="FM"
          @stampaslip=1
          if @riga[:ciclofisso]==true and @riga[:stampamagazzino]==false
            @stampaslip=0
          end
          @ciclost=@riga[:dapannello].split(";")        
        end  

        #----Aggiunta Forzatura Montato 16.10.14 disattivato script montato x velocità
        #if  @riga[:flag]=="M" and  (@ciclost.last=="90" or @ciclost.last=="10" or @ciclost.last=="5")
        #  #@ciclost.pop  #elimina ultimo valore array
        #  @ciclost[-1]="1"             #Forza il Montato        
        #end
        #----------Qualsiasi Classe Etichetta Diventa Montato 31.10.14
        if  @riga[:flag]=="M"
          ultima_fase=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[-1]}"} #Deterimino L'ultima Fase
          if ultima_fase!=nil and ultima_fase.tiporeparto=="Etichetta"
            @ciclost[-1]="1"             #Forza il Montato        
          end 
        end
        #------------------------------------------------

        @islaccato=@ciclo.islaccato
              
        @appo_ciclost=@ciclost.dup           #memorizzo ciclo prima di passare al recupero fasi (dup copia x valore non per riferimento)
              
        RecuperaFasi(@ciclost)  
        #puts @ciclost   		
		#puts @fase3.codice
 
        if @islaccato==true              #se laccato forza la stampa delle slip
         @stampaslip=1
        end  
		
		#puts @ciclost  #stampa ciclo prima di un elaborazione
 
        #attenzione arriva 0 o 1      
        if @riga[:abilitascript]==true     #rielabora la slip con uno script se esistente          
         PreProcessaSlip(@riga[:script])         
        end
             
        #if @salvaslip==true  #serve per gestire alcuni casi limite #abilitare per gestire salta slip
          SalvaSlip()
        #end
  end


  def RecuperaFasi(lista_fasi)

    #begin  #gestione eccezioni
    if @islaccato==true
      
      ultima_fase=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[-1]}"} #Deterimino L'ultima Fase
      if ultima_fase!=nil
        if ultima_fase.tiporeparto=="Etichetta"
          if @riga[:prelievolaccato]=="0000" or @riga[:prelievolaccato]==nil
            @ciclost[-1]="84"        
          else
            @ciclost[-1]=@riga[:prelievolaccato]  #aggiunta al laccato di un prelievo x walter
            @ciclost.push("84")
          end    
        else
          if @riga[:prelievolaccato]=="0000" or @riga[:prelievolaccato]==nil
            @ciclost.push("84")             #Attenzione Aggiunto 15.10.14 Per Gestire Casi Limite Laccato (se non trovo un etichetta finale aggiungo alla fine 84)
          else
            @ciclost.push(@riga[:prelievolaccato])  #aggiunta al laccato di un prelievo x walter
            @ciclost.push("84")
          end   
        end 
        @ciclost=@ciclost - ["98","99"]  #elimino fasi sparse di laccatura
      end  

    end
    #rescue Exception => msg 
    #puts "#{msg}  #{@riga[:codart]} #{@riga[:numero]}"
    #end

    contacicli=lista_fasi.count
	#puts contacicli
	#$lista_reparti=Reparti.all
	
    if contacicli>0          
      @fase1=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[0]}"}.clone    #Attenzione Se Non Trova Genera Eccezione (se trova ritorna un hash se non trova nil)
    end
    if contacicli>1
      @fase2=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[1]}"}.clone
    end
    if contacicli>2
      @fase3=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[2]}"}.clone    
	  #puts @fase3.class
    end
    if contacicli>3
      @fase4=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[3]}"}.clone
    end
    if contacicli>4
      @fase5=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[4]}"}.clone
    end
    if contacicli>5
      @fase6=$lista_reparti.detect{|f| f[:codice]=="#{@ciclost[5]}"}.clone
    end

    #In Caso Di Laccatura Trasformo (L'ultimo Reparto Se = Etichetta) in 84-spedizione x Laccatura  (AndAlso Su Ruby Funziona Di Default)    
    #if @ciclo.islaccato==true
    #  if contacicli==6 and @fase6.tiporeparto=="Etichetta"
    #    @fase6=$lista_reparti.detect{|f| f[:codice]=="84"}
    #  elsif contacicli==5 and @fase5.tiporeparto=="Etichetta" 
    #    @fase5=$lista_reparti.detect{|f| f[:codice]=="84"}
    #  elsif contacicli==4 and  @fase4.tiporeparto=="Etichetta" 
    #    @fase4=$lista_reparti.detect{|f| f[:codice]=="84"}
    #  elsif contacicli==3 and @fase3.tiporeparto=="Etichetta" 
    #    @fase3=$lista_reparti.detect{|f| f[:codice]=="84"}
    #  elsif contacicli==2 and @fase2.tiporeparto=="Etichetta" 
    #    @fase2=$lista_reparti.detect{|f| f[:codice]=="84"}
    #  elsif contacicli==1 and @fase1.tiporeparto=="Etichetta" 
    #    @fase1=$lista_reparti.detect{|f| f[:codice]=="84"}
    #  end        
    #end  

    #In Caso Di Laccatura Trasformo (L'ultimo Reparto Se = Etichetta) in 84-spedizione x Laccatura
    #if @ciclo.islaccato==true
    #lista_fasi=[@fase1,@fase2,@fase3,@fase4,@fase5,@fase6,@fase7,@fase8,@fase9]  #punta direttamente ai reparti
    #fase_etichetta=lista_fasi[contacicli-1]
    #puts "#{@fase2.codice}-#{@fase2.descrizione}"
    #@fase2.descrizione="9999"    
    #@cazz=$lista_reparti.detect{|f| f[:codice]=="#{@fase2.codice}"}
    #puts "#{@cazz.codice}-#{@cazz.descrizione} secondo"

  end


    def SalvaSlip()
      #puts @ciclo.riga_magazzino
      #File.open("gino.txt", 'a') { |file| file.write("#{@ciclo.riga_magazzino}\n") }  #appende in un file di testo        
      tempslip=TempSlip.new
      tempslip.id=@conta
      #tempslip.carico=@riga[:carico]
      tempslip.carico=@carico
      tempslip.numero=@riga[:numero]
      tempslip.matricola=@riga[:matricola]
      tempslip.scarico=@riga[:scarico]
      tempslip.codice=@ciclo.riga_magazzino[:codice]
      #tempslip.descrizione=@ciclo.riga_magazzino[:descrizione]
      tempslip.desc2=@riga[:desc2]
      tempslip.qta=1
      tempslip.l=@ciclo.riga_magazzino[:dimx]
      tempslip.a=@ciclo.riga_magazzino[:dimy]
      tempslip.p=@ciclo.riga_magazzino[:dimz]
      if @riga[:ciclofisso]==false  #i figli che prendo dal controllo magazzino non hanno le dimensioni mentre quelli con cilco fisso si
        tempslip.descrizione="#{@ciclo.riga_magazzino[:descrizione]} #{tempslip.l.to_i}X#{tempslip.a.to_i}X#{tempslip.p.to_i}" 
      else
        tempslip.descrizione=@ciclo.riga_magazzino[:descrizione]
      end
      #puts "#{tempslip.l} #{tempslip.a} #{tempslip.p}"
      #-------------------------------------------------------da verificare
      #tempslip.rl=@riga[:diml]
      #tempslip.ra=@riga[:dima]
      #tempslip.rp=@riga[:dimp]
      #-------------------------------------------------------da verificare
      tempslip.rl=tempslip.l
      tempslip.ra=tempslip.a
      tempslip.rp=tempslip.p
      if @riga[:fm].include?("X")
        @riga[:fm]="FM"
      end
      tempslip.fm=@riga[:fm]
      tempslip.eti=@riga[:eti]
      tempslip.pcod=@riga[:codart]      
      tempslip.pdes=@riga[:des]
      tempslip.pl=@riga[:diml]
      tempslip.pa=@riga[:dima]
      tempslip.pp=@riga[:dimp]
      tempslip.pcas=@riga[:pcas]
      tempslip.pfm=@riga[:fm]     #verificare cosa mettere
      tempslip.idp=0               #verificare cosa mettere
      tempslip.stampaslip=@stampaslip
      tempslip.ciclo=""  #@riga[:ciclo] non determinato
      tempslip.imballo=@riga[:imballo]
      tempslip.flag=@riga[:flag]
      #tempslip.islaccato=@islaccato    #spostato perchè in fase di traduzione varianti può cambiare
      tempslip.pxlavdx=@riga[:xlavdx]
      tempslip.pxlavsx=@riga[:xlavsx]
      tempslip.riga=@riga[:riga]
      tempslip.script=@script
      tempslip.percorso=@riga[:percorso]
      #-----------------------------------------------------------------Campi X Lavorazioni Brema
      tempslip.attivabrema=@attivabrema
      tempslip.bremal=@bremaL
      tempslip.bremaa=@bremaA    
      tempslip.bremap=@bremaP
      #----------------------------------------------------------------Aggiunta Note
      tempslip.nota1=@riga[:note1]
      tempslip.nota2=@riga[:note2] + "#{@riga[:desagg]}"
      tempslip.nota3=@riga[:note3]
      tempslip.nota4=@riga[:note4]
      #Aggiunto 24.02.2015 per evitare note doppie
      if @riga[:note5].to_s==@riga[:rnote5].to_s
        tempslip.nota5=@riga[:note5].to_s 
      else        
        tempslip.nota5=@riga[:note5].to_s+@riga[:rnote5].to_s  #caricocomp 3cad non porta la nota5 di rordine
      end
      tempslip.nota6=@riga[:note6]
      #----------------------------------------------------------------Aggiunta Note


      #-----------------------------------------------------------------differenziato se ciclo fm o Standard
      conteggio_fase=0

      if @fase1 != nil
        tempslip.c1=@fase1.codice
        tempslip.dc1=@fase1.descrizione
      end  

      if @fase2 != nil        
        tempslip.c2=@fase2.codice
        tempslip.dc2=@fase2.descrizione         
      end

      if @fase3 != nil        
        tempslip.c3=@fase3.codice
        tempslip.dc3=@fase3.descrizione
      end 
 
      if @fase4 != nil
        tempslip.c4=@fase4.codice
        tempslip.dc4=@fase4.descrizione 
      end  

      if @fase5 != nil
        tempslip.c5=@fase5.codice
        tempslip.dc5=@fase5.descrizione
      end

      if @fase6 != nil
        tempslip.c6=@fase6.codice
        tempslip.dc6=@fase6.descrizione
      end

      #rivaluta al volo
      #if @islaccato==false
      #  eval("tempslip.c#{conteggio_fase}=84 /n ")
      #end   

      #----------------------------------------------------------------Inserimento Varianti Figlio (if in linea rallenta di circa 5 secondi l'elaborazione)
      #var=@riga[:var].split(";")
      #     
      #if var.count>=1
      #  #puts var[0]
      #  tempslip.v1=var[0].split('=')[0] + " = " + TraduciVariante(var[0]) if var[0].size>2
      #end
      #if var.count>=2
      #   #puts var[1]        
      #   tempslip.v2=var[1].split('=')[0] + " = " + TraduciVariante(var[1])  if var[1].size>2
      #end
      #if var.count>=3 
      #   tempslip.v3=var[2].split('=')[0] + " = " + TraduciVariante(var[2])  if var[2].size>2
      #end
      #if var.count>=4
      #   tempslip.v4=var[3].split('=')[0] + " = " + TraduciVariante(var[3])  if var[3].size>2
      #end
      #if var.count>=5
      #   tempslip.v5=var[4].split('=')[0] + " = " + TraduciVariante(var[4])  if var[4].size>2
      #end
      #if var.count>=6
      #   tempslip.v6=var[5].split('=')[0] + " = " + TraduciVariante(var[5])  if var[5].size>2
      #end

      #----------------------------------------------------------------Inserimento Varianti Padre - Figlio
      var=@riga[:var].split(";")

      if @islaccato==false  #---Non Laccato Uso Le Stesse Varianti Padre x il Figlio
     
        if var.count>=1
           tempslip.pv1=var[0].split('=')[0] + " = " + TraduciVariante(var[0])  if var[0].size>2
           tempslip.v1 = tempslip.pv1
        end
        if var.count>=2
           tempslip.pv2=var[1].split('=')[0] + " = " + TraduciVariante(var[1])  if var[1].size>2
           tempslip.v2 = tempslip.pv2
        end
        if var.count>=3
           tempslip.pv3=var[2].split('=')[0] + " = " + TraduciVariante(var[2])  if var[2].size>2
           tempslip.v3 = tempslip.pv3
        end
        if var.count>=4
           tempslip.pv4=var[3].split('=')[0] + " = " + TraduciVariante(var[3])  if var[3].size>2
           tempslip.v4 = tempslip.pv4
        end
        if var.count>=5
           tempslip.pv5=var[4].split('=')[0] + " = " + TraduciVariante(var[4])  if var[4].size>2
           tempslip.v5 = tempslip.pv5
        end
        if var.count>=6
           tempslip.pv6=var[5].split('=')[0] + " = " + TraduciVariante(var[5])  if var[5].size>2
           tempslip.v6 = tempslip.pv6
        end                  

      else    #---Laccato Forzo Le Prime 2 Varianti Melaminico e LaccoDa

        if var.count>=1
           tempslip.pv1=var[0].split('=')[0] + " = " + TraduciVariante(var[0])  if var[0].size>2
           tempslip.v1 = "501 = Melaminico"
        end
        if var.count>=2
           tempslip.pv2=var[1].split('=')[0] + " = " + TraduciVariante(var[1])  if var[1].size>2
           tempslip.v2 = "401 = #{@riga[:laccodal]}"
        end
        if var.count>=3
           tempslip.pv3=var[2].split('=')[0] + " = " + TraduciVariante(var[2])  if var[2].size>2
           tempslip.v3 = tempslip.pv3
        end
        if var.count>=4
           tempslip.pv4=var[3].split('=')[0] + " = " + TraduciVariante(var[3])  if var[3].size>2
           tempslip.v4 = tempslip.pv4
        end
        if var.count>=5
           tempslip.pv5=var[4].split('=')[0] + " = " + TraduciVariante(var[4])  if var[4].size>2
           tempslip.v5 = tempslip.pv5
        end
        if var.count>=6
           tempslip.pv6=var[5].split('=')[0] + " = " + TraduciVariante(var[5])  if var[5].size>2
           tempslip.v6 = tempslip.pv6
        end

      end

      tempslip.tipoelaborazione="Union"
      tempslip.cliente=riga[:cliente]
      tempslip.barcode="X.#{@riga[:numero]}.#{@riga[:matricola]}"
      tempslip.var3cadrordine=riga[:var]  #salva la lista di varianti del padre in caricocomp-rordine

      tempslip.islaccato=@islaccato  #spostato perchè in fase di traduzione varianti può cambiare

      tempslip.anticipo=Anticipi.cerca(@riga[:pcod]) #Al Monento Solo In Ecad Non Abilitato In 3Cad

      tempslip.save
    end


  def TraduciVariante(stringavariante)
    #------Sistema A Memoria (Più efficente con server sql poco performante)
    appo_var=$lista_varianti.select{|f| f.codvar=="#{stringavariante.split('=')[0]}" and f.codopz=="#{stringavariante.split("=")[1]}"}
    if appo_var.count==1
        #ATTENZIONE IN FASE DI PROVA -- EVENTUALMENTE DIFFERENZIARE LA DESCRIZIONE CON CARATTERE SPECIALE 13.10.14
        if @islaccato==true and (appo_var[0].des.downcase.include?("punto")==true or appo_var[0].des.downcase.include?("riga")==true)
          @islaccato=false
          puts "Modifico Texture Da Laccato A Normale"
          #File.open("TEST.txt", 'a') { |file| file.write("#{@riga}\n") }  #appende in un file di testo  x TEST      
        end
        return appo_var[0].des
    else      
        return ""
    end 
  end

  def PreProcessaSlip(script)
    begin
      puts "Elaboro Script #{script}"
      script = IO.read("K:/Ecadpro/RubyLogyUnion/script/#{@riga[:script]}")
	  #puts "Processo Ordine #{@riga[:numero]} #{@riga[:codice]}"	  
	  #puts "riga------------------------"
	  #puts @riga
	  #puts " emiliano #{@fase3.to_s}"
	  
      eval(script)
      @script=@riga[:script] + "-ok"
    rescue SyntaxError => se      ##Intercetta Errori Di Sintassi
     puts "Riscontrati Errori Script Ciclo cod:#{@riga[:xcodice]}" 
     @script=@ciclo.script + "-errore"
    end
  end

end