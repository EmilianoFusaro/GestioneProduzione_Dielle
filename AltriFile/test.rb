require 'spreadsheet'

book = Spreadsheet.open('magazzino.xls')  #Accedo al file xls indicato
sheet1 = book.worksheet('SEMILAVORATI')   #Accedo al foglio indicato
primariga=true



lista_magazzino=[]

sheet1.each do |row|
  
  break if row[0].nil? # esco dal ciclo con la prima riga vuota
  
  if primariga==true
    row_appo=row
    puts row_appo.size
    primariga=false
  end        

  #h={}
  #aagiunta di chiave-valore dinamica
  #h[:cod]=2
  #h[:des]="prova"
  #dichiarazione standard
  #H = Hash["codice" => row[0],"descrizione" => row[1],"dimx" => row[2],"dimy" => row[3],"dimz" => row[4]]

  H = Hash.new
  H[:codice]=row[0]
  H[:des]=row[1]
  H[:dimx]=row[2]
  H[:dimy]=row[3]
  H[:dimz]=row[4]
  H[:bianco]=row[5]
  H[:larice]=row[6]
  H[:rovere]=row[7]
  H[:corda]=row[8]
  H[:tabacco]=row[9]
  H[:perla]=row[10]
  H[:naturale]=row[11]
  H[:lava]=row[12]
  H[:mandarino]=row[13]
  H[:girasole]=row[14]
  H[:magnolia]=row[15]
  H[:alabastro]=row[16]
  H[:avio]=row[17]
  H[:verde]=row[18]
  H[:glicine]=row[19]


  #puts row.join(',') # looks like it calls "to_s" on each cell's Value
  #puts row[0].to_s 
  #puts H 

  lista_magazzino << H.to_s   
  
end

puts lista_magazzino[1]
puts lista_magazzino[2]
