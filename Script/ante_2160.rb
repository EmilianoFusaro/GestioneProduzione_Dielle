#lo spessore del pannello è di 18 mm
#--------------le ante del reparto 2160 le forzo a 18
if @tipo_elaborazione=="Logy"
  @riga[:p]=18
  @riga[:pp]=18
  @riga[:rp]=18
else
  @riga[:dimp]=18
  @riga[:adimp]=18
end