require "rubygems"
require "prawn"
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/svg_outputter'
require 'prawn-svg'
require 'fileutils'

#permette l'inserimento di caratteri speciali
Encoding.default_external = 'UTF-8'

$nome_file="StampaSlip"

load "K:/Ecadpro/RubyLogyUnion/connessione.rb"
load "K:/Ecadpro/RubyLogyUnion/CaricaModuloStampa.rb"


#-------------------------Elenco Variabili
#carico="0008"
carico=ARGV[0]
filtroordini=ARGV[1]

$colore_bindelle=Carico.colore_carico(carico)  #identifica il colore delle bindelle
#puts $colore_bindelle
#x test 
#$colore_bindelle="ffffff"

#newslip=1
#if newslip==0
##OLD SLIP
#if carico.include? "XXXX"
#  modulo_originale1=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",0,0)
#  modulo_originale2=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",427,0)
#  modulo_originale3=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",0,-280)
#  modulo_originale4=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",427,-280)
#else
#  modulo_originale1=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",0,0)
#  modulo_originale2=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",427,0)
#  modulo_originale3=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",0,-280)
#  modulo_originale4=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",427,-280)
#end
#else  
##NEW SLIP
if carico.include? "XXXX"
  modulo_originale1=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",0,0)
  modulo_originale2=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",427,0)
  modulo_originale3=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",0,-280)
  modulo_originale4=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip_test.mst",427,-280)
else
  modulo_originale1=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",0,0)
  modulo_originale2=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",421,0)
  modulo_originale3=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",0,-295)
  modulo_originale4=CaricaModuloStampa("K:/Ecadpro/RubyLogyUnion/ModuliStampa/slip.mst",421,-295)
end 
#end

#puts modulo_originale
#file_testo=""

#update_ds = DB["UPDATE albums SET name = ? WHERE name = ?", 'MO', 'RF']
#update_ds.update

#update_ds = DB_ECAD["update tempslip set desc2=replace(desc2,'§','') where Carico=#{Carico} and desc2 like '%§%'"]
#update_ds.update


#pdf = Prawn::Document.new(:page_size => 'A4',:page_layout => :landscape,:margin => [1],:background_color => "FFFFCC")  #background non funziona
pdf = Prawn::Document.new(:page_size => 'A4',:page_layout => :landscape,:margin => [1])
pdf.font_size 8 

#puts $colore_bindelle
pdf.fill_color "#{$colore_bindelle}"

if carico.include? "XXXX"
  #OLD SLIP
  #posizone x posizione y (600 e dall'alto),dimensone x,dimensone y
  pdf.fill_rectangle [-1, 600], 845, 600
  pdf.fill_color 'ffffff'
  pdf.fill_rectangle [-1, 116], 822, 82     #in basso sx
  pdf.fill_rectangle [-1, 396], 822, 82     #in alto sx
  pdf.fill_color '000000'
else
  #NEW SLIP
  #posizone x posizione y (600 e dall'alto),dimensone x,dimensone y
  pdf.fill_rectangle [-1, 600], 845, 600
  pdf.fill_color 'ffffff'
  pdf.fill_rectangle [-1, 101], 845, 82     #in basso sx
  pdf.fill_rectangle [-1, 396], 845, 82     #in alto sx
  pdf.fill_color '000000'
end

conta_slip=1
if carico.include? "C"   #in base al tipo di carico seleziona le slip non laccate o solo laccate
    #tempslip=TempSlip.where("Carico='#{carico}' #{$filtroordini} And StampaSlip=1 And Islaccato=1").order("ID") #.limit(4)  #questa sintassi è comunque SBAGLIATA generebbe: ORDER BY N'ID'
    tempslip=TempSlip.where("Carico='#{carico}' #{$filtroordini} And StampaSlip=1 And Islaccato=1").order(:c1) #.limit(4)
    cartella_dest="LACCATI"
else    

    #tempslip=TempSlip.where("Carico='#{carico}' #{$filtroordini} And StampaSlip=1 And Islaccato=0").order("ID") #.limit(4)
    tempslip=TempSlip.where("Carico='#{carico}' #{$filtroordini} And StampaSlip=1 And Islaccato=0").order(:c1) #.limit(4)
    cartella_dest="CARICHI"
end    

tempslip.each{ |riga| 
 
  #puts "#{riga.id}--#{riga.c1}--#{riga.codice}--#{riga.descrizione}"

  #puts riga.pxlavdx
  #appo=riga.desc2 #.delete("\xF5")
  #appo=appo.delete("§")

  #puts "#{riga.id} #{riga.descrizione} #{riga.desc2}"
  #File.open("gino.txt", 'w') { |file| file.write(modulo_originale1 ) }

  case conta_slip
  when 1
  	#puts modulo_originale1
  	eval(modulo_originale1)  
    #File.open("gino.txt", 'w') { |file| file.write(modulo_originale1 ) }
    #file_testo=file_testo+modulo_originale1
  when 2
  	#puts modulo_originale2
 	  eval(modulo_originale2)  
    #file_testo=file_testo+modulo_originale2
  when 3
  	#puts modulo_originale3
  	eval(modulo_originale3)  
    #file_testo=file_testo+modulo_originale3
  when 4
  	#puts modulo_originale4)
  	eval(modulo_originale4)
    #file_testo=file_testo+modulo_originale4  
  	conta_slip=0
  	pdf.start_new_page    
    pdf.fill_color "#{$colore_bindelle}"

    if carico.include? "XXXX"
      #OLD SLIP
      #posizone x posizione y (600 e dall'alto),dimensone x,dimensone y
      pdf.fill_rectangle [-1, 600], 845, 600
      pdf.fill_color 'ffffff'
      pdf.fill_rectangle [-1, 116], 822, 82     #in basso sx
      pdf.fill_rectangle [-1, 396], 822, 82     #in alto sx
      pdf.fill_color '000000'
    else
      #NEW SLIP
      #posizone x posizione y (600 e dall'alto),dimensone x,dimensone y
      pdf.fill_rectangle [-1, 600], 845, 600
      pdf.fill_color 'ffffff'
      pdf.fill_rectangle [-1, 101], 845, 82     #in basso sx
      pdf.fill_rectangle [-1, 396], 845, 82     #in alto sx
      pdf.fill_color '000000'
    end  

  end 	

  conta_slip=conta_slip+1 
 
  #break  #per stampare solo 1 pagina
}

#------------------------------------Se Non Presente Crea La Directory Con il Nome Del Carico
unless File.directory?("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}")
  FileUtils.mkdir_p("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}")
  else  
  #elimina file vecchi presenti
  FileUtils.rm_rf Dir.glob("K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}/*") 
  #verifica che siano stati eliminati tutti i file
  #Dir["**/*"].length
  if Dir["K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}/*"].length>0
    #-------------------------------------------------------Invio Mail Di Allert perchè stanno elaborando con documenti pdf aperti (08.04.15)
require 'net/smtp'
message = <<EOF
From: Avviso Carico<fusaro@dielle.it>
To: RECEIVER <fusaro@dielle.it>
Subject: Attenzione Elaborazione Carico Con Elementi Aperti #{carico}
Attenzione Elaborazione Carico Con Elementi Aperti #{carico}.
EOF
smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls
smtp.start('gmail.com', 'fusaro@dielle.it', 'sole33', :login)
smtp.send_message message, 'fusaro@dielle.it' , 'fusaro@dielle.it'
smtp.finish
    #$esito=false
    puts "ATTENZIONE!! SI STA CERCANDO DI ELABORARE UN CARICO CON DEI DOCUMENTI APERTI!!"
    puts "CHIUDERE TUTTI I DOCUMENTI E RIPETERE LA PROCEDURA DI ELABORAZIONE"
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
    gino=STDIN.gets.chomp()
  end
end

pdf.render_file "K:/Ecadpro/RubyLogyUnion/#{cartella_dest}/#{carico}/#{carico}_Slip.pdf"


#File.open("gino.txt", 'w') { |file| file.write(modulo_originale) }
#File.open("gino.txt", 'w') { |file| file.write(file_testo) }