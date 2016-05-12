#script per la modifica delle dimensioni della slip dei frontali cassettone MODUS



if @tipo_elaborazione=="Logy"
  
  @riga[:pcas]=@riga[:pa]  #setta profondità cassetto finita
  #@riga[:a]=@riga[:a]-171
  @riga[:pa]=@riga[:pa]-171
  @riga[:ra]=@riga[:ra]-171

  #@riga[:p]=@riga[:p]-291
  @riga[:pp]=@riga[:pp]-291
  @riga[:rp]=@riga[:rp]-291
  #puts "frontale cassettone"
  
end
 
