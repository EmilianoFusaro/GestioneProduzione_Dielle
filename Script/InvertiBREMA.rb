#script per l'inversione delle dimensioni in BREMA

#-----------------------------Attivate Misure Per Brema
@attivabrema=true
#-------------------------@riga[:diml],@riga[:dima],@riga[:dimp] x Union
#-------------------------@riga[:pl],@riga[:pa],@riga[:pp] x Logy
#@bremaL=@riga[:dima]
#@bremaA=@riga[:diml]
#@bremaP=@riga[:dimp]

if @tipo_elaborazione=="Logy"
 @bremaL=@riga[:pa]
@bremaA=@riga[:pl]
@bremaP=@riga[:pp]
else
@bremaL=@riga[:dima]
@bremaA=@riga[:diml]
@bremaP=@riga[:dimp]
end
