require 'rubygems'
require 'fileutils'
require 'sequel'
require 'date'
Encoding.default_external = 'UTF-8'

DB_SM = Sequel.ado(:conn_string=>'Provider=SQLOLEDB.1;User ID=sa;Password=sistema;Initial Catalog=Simul;Data Source=10.0.2.8')   #---Connessione Simul

class Pr_Insider < Sequel::Model(DB_SM[:pr_insider])
  set_primary_key [:programma]
end


Pr_Insider.dataset.destroy                                    #Svuota Completamente La Tabella

Dir.foreach("C:/Insider/").each do |item|                     #Esemino La Directory Corrente
  riga_record=Pr_Insider.new                                  #Creo una nuova riga
  riga_record.programma=item
  riga_record.datacreazione=File.mtime("C:/Insider/#{item}")  #Data Creazion File
  riga_record.save                                            
end


#---Esempi Di Codice
#puts item.ctime
#puts File.ctime("C:/Insider/#{item}") 
#puts "#{item}----#{File.mtime("C:/Insider/#{item}") }"


#---Documentazione Utilizzata
#https://www.google.it/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=ruby%20list%20files%20in%20directory%20by%20date
#https://www.ruby-forum.com/topic/828544
#https://www.google.it/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=ruby%20file%20date%20creation
#http://stackoverflow.com/questions/4009288/how-do-i-get-the-file-creation-time-in-ruby-on-windows
#http://stackoverflow.com/questions/10580728/is-it-possible-to-read-a-files-modification-date-with-ruby

#---Ottima Lista Sui Linguaggi Di Programmazione
#http://www.programming.raskrjal.net/default.aspx
#http://www.programming.raskrjal.net/ruby/ruby0000.html
#http://www.programming.raskrjal.net/csharp/csh00000.html
#http://ema.codiceplastico.com/page10/

#---Raccoglitori Di Startup
#http://www.imolinfo.it/
#http://www.avanscoperta.it/it/
#http://www.cantierecreativo.net/
#http://www.ideato.it/
#http://www.tiragraffi.it/
#http://it.startupbusiness.it/
#http://www2.mokabyte.it/cms/article.run?articleId=CSO-5SH-OM6-9AV_7f000001_29118337_6154e0d4
#http://www.betterdecisionsforum.com/
#http://talentgarden.org/
#http://www.lawyersinaction.eu/
#http://www.expodellestartup.com/
#http://2015.kerning.it/
#http://2015.phpday.it/
#http://2015.jsday.it/
#http://www.bettersoftware.it/


#---Notebook
#http://www.webnews.it/recensioni/dell-xps-15-2015/
#http://www.webnews.it/recensioni/acer-aspire-v-17-nitro/
#http://www.acer.it/ac/it/IT/content/model/NX.MTHET.002

