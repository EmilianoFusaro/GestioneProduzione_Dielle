#Mei Cassetti che non hanno altri script imposta la profondit� del cassetto

if @tipo_elaborazione=="Union"
  @riga[:pcas]=@riga[:odima]  #setta profondit� cassetto finita odima=dima originale non modificata 
elsif @tipo_elaborazione=="Logy"
  @riga[:pcas]=@riga[:pa]  #setta profondit� cassetto finita
end




