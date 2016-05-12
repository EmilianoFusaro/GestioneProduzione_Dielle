#il kit maniglione deve arrivare con descrizioni differenti

@riga[:desc2]=""       #----Azzera La 2° Descrizione Che Porta Un Informazione Ripetuta

#--------------Elimino Dalle Varianti La Variante PAZ (non serve)
inizio_paz=@riga[:varianti].index("PAZ")

if inizio_paz != nil
  fine_paz=@riga[:varianti].index(";",inizio_paz)
  @riga[:varianti][inizio_paz..fine_paz]=""  
end

#--------------Modifico Il Padre Che Deve Essere Lo Stesso CodiceFIglio
@riga[:pcod]=@riga[:codice]
@riga[:pdes]=@riga[:descrizione]
@riga[:pvarianti]=@riga[:varianti]
@riga[:note4]=""



