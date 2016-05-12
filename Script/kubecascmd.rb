#script per la modifica delle dimensioni della slip dei frontali cassetto KUBE
load "K:/ecadpro/RubyLogy/funzioni.rb"

unless  @riga[:descrizione].include? "DISTANZIALE"                                           #se non è un distanziale

	if @riga[:codice]=="56017131" or @riga[:codice]=="56017331"
	@riga[:a]=@riga[:a]-194
	@riga[:pa]=@riga[:pa]-194
	@riga[:ra]=@riga[:ra]-194

	@riga[:p]=@riga[:p]-180
	@riga[:pp]=@riga[:pp]-180
	@riga[:rp]=@riga[:rp]-180
	#puts "frontale cmd"

	elsif @riga[:codice]=="66610551" or @riga[:codice]=="66610552"
	@riga[:l]=@riga[:l]-24
	@riga[:pl]=@riga[:pl]-24
	@riga[:rl]=@riga[:rl]-24

	@riga[:a]=@riga[:a]-218
	@riga[:pa]=@riga[:pa]-218
	@riga[:ra]=@riga[:ra]-218

	@riga[:p]=@riga[:p]-186
	@riga[:pp]=@riga[:pp]-186
	@riga[:rp]=@riga[:rp]-186
	#puts "distanziale cmd"

	elsif @riga[:codice]=="56047131" or @riga[:codice]=="56047331"
	@riga[:a]=@riga[:a]-294
	@riga[:pa]=@riga[:pa]-294
	@riga[:ra]=@riga[:ra]-294

	@riga[:p]=@riga[:p]-180
	@riga[:pp]=@riga[:pp]-180
	@riga[:rp]=@riga[:rp]-180
	#puts "frontale cmo"

	elsif @riga[:codice]=="66610561" or @riga[:codice]=="66610562"
	@riga[:l]=@riga[:l]-24
	@riga[:pl]=@riga[:pl]-24
	@riga[:rl]=@riga[:rl]-24

	@riga[:a]=@riga[:a]-318
	@riga[:pa]=@riga[:pa]-318
	@riga[:ra]=@riga[:ra]-318

	@riga[:p]=@riga[:p]-186
	@riga[:pp]=@riga[:pp]-186
	@riga[:rp]=@riga[:rp]-186
	#puts "distanziale cmo"
	end

else                                                                                                           #se è un distanziale
 
        #puts "distanziale"
		reset_fasi  #cancella tutte le fasi precedenti
		
		#unless @riga[:pfm]=="FM" 		 #----STANDARD
          @fase1=Fase.new("2181_12","FRON.CASS.SP.12 MM - MODUS")
	      #@fase2=Fase.new("5","CASSETTI SMONTATO")
	      #---Modificato 31.10.14
	      @fase2=Fase.new("010","MONTATO")
		  
		  @riga[:rl]=@riga[:l]
		  @riga[:ra]=@riga[:a]
		  @riga[:rp]=@riga[:p]
		  
		#else                                           #-----FM (MA BISOGNA VEDERE COME RICONOSCERLO)
		
        #  @fase1=Fase.new("1680","PREL PANNELLI")
	    #  @fase2=Fase.new("2010","SALVADOR")
     	#  @fase3=Fase.new("3316","HOMAG BORDO 4 LATI 14/10")	
		#  @fase4=Fase.new("4080","BREMA GRANDE")
		#  @fase5=Fase.new("5","CASSETTI  SMONTATO")
        #end  

end 