#Elabora Anticipi 04.11.14 Emiliano


require "sequel"
require 'fileutils'
require 'date'
#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'


DB_3CAD = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=3cad;Data Source=10.0.2.8') 


class Macroapp < Sequel::Model(DB_3CAD[:macroapp])
  # => include Enumerable	
  set_primary_key [:cat,:cod]
end

Macroapp.each do |row|
  
  riga=row.macro.split(",")

  #puts riga[2].to_a
  
  #if riga[2].is_a? Integer
    row.diml=riga[2]
  #end
  
  #if riga[3].is_a? Integer
    row.dima=riga[3]
  #end
  
  #if riga[4].is_a? Integer
    row.dimp=riga[4]
  #end
  
  row.save
end