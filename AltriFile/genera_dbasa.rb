#Questa procedura serve per generare il file csv da passare in distinta ad asa

require 'rubygems'
require "sequel"
require "csv"
#Encoding.default_external = 'UTF-8'

DB_ECAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=Sistema;Initial Catalog=Dielle;Data Source=10.0.2.8\ECADPRO')  #---Connessione DB Ecad-Dielle


class DbAsa_Da_Generare < Sequel::Model(DB_ECAD[:dbasa_da_generare])              
   set_primary_key [:cod]
end

percorso_file='//srv-gest/DSKPGM/ASA/TEXT/CAZZO.csv'

dbasa_da_generare=DbAsa_Da_Generare.all

arr = Array.new(15, "") #crea un array di 15 celle con valore ""
#CSV.open(percorso_file, "w:UTF-8") do |csv| 
CSV.open(percorso_file, "w") do |csv| 
  csv << ["Cod.distinta(15);Cod.componente(15);Quantita(8,3);Sfrido(2,1);Variante1(2);Variante2(2);Variante3(2);Variante4(2);Variante5(2);Variante6(2);Variante7(2);IndicativoSVP(1,0);Nota1(30);Nota2(30);CodiceForzatura(3)"]
  dbasa_da_generare.each do |riga|
    arr = Array.new(15, "")
    arr[0]=riga.cod
    arr[1]=riga.codfig
    arr[2]="1"
    csv << [arr.join(";")]
  end
end
