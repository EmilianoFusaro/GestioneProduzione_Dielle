#Mei Cassetti che non hanno altri script imposta la profondità del cassetto

if @tipo_elaborazione=="Union"
  @riga[:pcas]=@riga[:odima]  #setta profondità cassetto finita odima=dima originale non modificata 
elsif @tipo_elaborazione=="Logy"
  @riga[:pcas]=@riga[:pa]  #setta profondità cassetto finita
end




