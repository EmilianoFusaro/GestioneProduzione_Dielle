#elemento particolare viente trattato in modo particolare
#Visto Anche Con Adrea Ditadi 25.07.14


#-----------------------------------------------------------------------------------------Caso In Cui 19942017S HA matricola in Tipologie
=begin
if @riga[:pcod]=="19942017S" #deve escludere questo codice per ridondanza distinta
  @salvaslip=false
  #puts "escludi slip"
else  
  @riga[:pcod]="0#{@riga[:pcod]}"
  @riga[:qta]=1           #sempre 1 non viene raggruppata
  @riga[:l]=@riga[:rl]
  @riga[:a]=@riga[:ra]
  @riga[:p]=@riga[:rp]
  @riga[:pl]=@riga[:rl]
  @riga[:pa]=@riga[:ra]
  @riga[:pp]=@riga[:rp]
  #puts "modifica salvaslip"
end
=end

#-----------------------------------------------------------------------------------------Caso In Cui 19942017S NON HA matricola in Tipologie
  @riga[:pcod]="0#{@riga[:pcod]}"
  @riga[:qta]=1           #sempre 1 non viene raggruppata
  @riga[:l]=@riga[:rl]
  @riga[:a]=@riga[:ra]
  @riga[:p]=@riga[:rp]
  @riga[:pl]=@riga[:rl]
  @riga[:pa]=@riga[:ra]
  @riga[:pp]=@riga[:rp]


