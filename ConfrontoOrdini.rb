#Script Per Confrontare La Differenza Tra 2 Ordini

require "sequel"

DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Ecadmaster;Data Source=10.0.2.8\ECADPRO')
DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8')


num_ecad="581089"
num_3cad="570673"

#num_ecad="581077"
#num_3cad="570671"
#num_ecad="580830"
#num_3cad="264643"
	
class OrdineEcad < Sequel::Model(DB_ECAD[:rordine])
	set_primary_key [:percorso, :numero, :riga]
end

class Ordine3cad < Sequel::Model(DB_3CAD[:rordine])
	set_primary_key [:percorso, :numero, :riga]
end

#load "k:/ecadpro/rubylogyunion/ConfrontoOrdini.rb"
#sql=self.where(:cod=>codice).select(:anticipo).first #forzo il risultato in un hash

#a=OrdineEcad.where(:numero=>"580601").select(:codart).order(:codart).all.to_a
#b=Ordine3cad.where(:numero=>"570491").select(:codart).order(:codart).all.to_a


#a=OrdineEcad.where(:numero=>num_ecad).select(:codart).order(:codart)
#b=Ordine3cad.where(:numero=>num_3cad).select(:codart).order(:codart)

a=OrdineEcad.where("numero=#{num_ecad} and riga<>1").select(:codart).order(:codart)
b=Ordine3cad.where("numero=#{num_3cad} and riga<>1").select(:codart).order(:codart)

#puts "Ordine Ecad_____________________________________"
a1=[]
a.each do |valore|
  a1.push(valore.codart)
end
#puts "Ordine 3cad_____________________________________"
b1=[]
b.each do |valore|
  b1.push(valore.codart)
end

system 'cls' #esegue pulizia schermo
puts "Differenza_____________________________________Ecad Ordine: #{num_ecad}"
puts a1-b1

puts "Differenza_____________________________________3cad Ordine: #{num_3cad}"
puts b1-a1


if a1.size != b1.size
  puts "Componenti Ecad #{a1.size}"
  puts "Componenti 3cad #{b1.size}"
end

