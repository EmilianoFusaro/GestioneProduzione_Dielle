#script per la modifica delle dimensioni della slip dei frontali cassettone MODUS

#lista_codici_a="66610581;66610582;66610681;66610682;66610781;66610782;66610881;66610882;66610981;66610982"

#unless (@riga[:codice].include? lista_codici_a)==false
	#puts @riga[:pa]
	#puts @riga[:pp]
	#puts @riga[:pl]

	 
	@riga[:pcas]=@riga[:pa]  #setta profondità cassetto finita
	
	if @riga[:pa]<390

		#@riga[:a]=@riga[:a]-230  #misure anagrafica figlio forse sono già giuste
		@riga[:pa]=@riga[:pa]-230
		@riga[:ra]=@riga[:ra]-230
		
		#@riga[:p]=@riga[:p]-132 #misure anagrafica figlio forse sono già giuste
		@riga[:pp]=@riga[:pp]-132
		@riga[:rp]=@riga[:rp]-132
		#puts "frontale cassettone"
		#puts @riga[:codice]

#-----------------------------Attivate Misure Per Brema
		@attivabrema=true
		@bremaL=@riga[:pl]
		@bremaA=@riga[:pa]
		@bremaP=25

	elsif @riga[:pa]>390
	
		#@riga[:a]=@riga[:a]-330  #misure anagrafica figlio forse sono già giuste
		@riga[:pa]=@riga[:pa]-330
		@riga[:ra]=@riga[:ra]-330

		#@riga[:p]=@riga[:p]-132  #misure anagrafica figlio forse sono già giuste
		@riga[:pp]=@riga[:pp]-132
		@riga[:rp]=@riga[:rp]-132
		#puts "pippo"		
		#-----------------------------Attivate Misure Per Brema
		@attivabrema=true
		@bremaL=@riga[:pl]
		@bremaA=@riga[:pa]
		@bremaP=25

	end

#end