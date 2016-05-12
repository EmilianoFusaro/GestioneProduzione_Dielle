# SQL Server
#Sequel.connect('ado:///sequel_test?host=server%5cdb_instance')
#Sequel.connect('ado://user:password@server/database?host=server%5cdb_instance&provider=SQLNCLI10')
# Access 2007
#Sequel.ado(:conn_string=>'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=drive:\path\filename.accdb')
# Access 2000
#Sequel.ado(:conn_string=>'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=drive:\path\filename.mdb')
# Excel 2000 (for table names, use a dollar after the sheet name, e.g. Sheet1$)
#Sequel.ado(:conn_string=>'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=drive:\path\filename.xls;Extended Properties=Excel 8.0;')


#---Connessione A Database Access

require 'rubygems'
require 'fileutils'
require "sequel"
#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'




DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8') 

class Xbed3cad < Sequel::Model(DB_3CAD[:Xbed3cad])
  set_primary_key [:percorso, :numero, :riga]
end

class XbedEcad < Sequel::Model(DB_3CAD[:XbedEcad])
  set_primary_key [:percorso, :numero, :riga]
end


appo_codicemacro=""
Xbed3cad.order(:NUMERO).order_more(:RIGA).each do |row|
  if  row.codmacro.size>5
     appo_codicemacro=row.codmacro
  else
     row.codmacro=appo_codicemacro
  	 row.save	 
  end  
end







