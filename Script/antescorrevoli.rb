#la larghezza delle AnteScorr devono generare un pannello 20 mm più corto e di spoessore 18
#-----------------------------Disattivati Per Problemi Virgilio Con Descrizioni
#@riga[:a]=@riga[:a]-20
#@riga[:pa]=@riga[:pa]-20
#@riga[:ra]=@riga[:ra]-20


@riga[:p]=18
@riga[:pp]=18
@riga[:rp]=18

#-----------------------------Attivate Misure Per Brema
if @tipo_elaborazione=="Logy"
  @attivabrema=true
  @bremaL=@riga[:pl]
  @bremaA=@riga[:pa]-20
  @bremaP=18
elsif @riga[:percorso]=="DIELLEEV"  #solo se viene da evolution da 3cad viene già accorciata dalla brema
  @attivabrema=true
  @bremaL=@riga[:diml]
  @bremaA=@riga[:dima]-20
  @bremaP=18
end

#------------------------------------------------------------------------------------------------------Aggiunto 02.10.14
#Queste Ante Contengono La Variante Del Profilo Che Possono Creare Un Falso Laccato.
#521=009                                                                   (Profilo Laccato)
#502=003;502=004;502=006;502=009;502=1.102;502=1.104;502=3.302;502=4.402;  (Anta Laccata)
if @tipo_elaborazione=="Logy"
  var_antasc=@riga[:pvarianti].split(";")  #Considero le varianti del figlio (pannello anta)
else
  var_antasc=@riga[:var].split(";")
end
#puts $stringa_laccati_scorrevoli
#puts var_antasc
@islaccato=false   
var_antasc.each{ |i| 
  if ($stringa_laccati_scorrevoli.include? i) and (i.size>=6)   
    @islaccato=true
    break
  end
  #puts "#{$stringa_laccati_scorrevoli} ----> #{i}"
}

#puts @islaccato
##puts "#{@riga[:descrizione]} #{@islaccato}"   #Visualizza Lo Stato Dei Pannelli