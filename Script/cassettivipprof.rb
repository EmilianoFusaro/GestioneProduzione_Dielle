#Mei Cassetti che non hanno altri script imposta la profonditÓ del cassetto

if @tipo_elaborazione=="Union"
  @riga[:pcas]=@riga[:odima]  #setta profonditÓ cassetto finita odima=dima originale non modificata 
elsif @tipo_elaborazione=="Logy"
  @riga[:pcas]=@riga[:pa]  #setta profonditÓ cassetto finita
end




