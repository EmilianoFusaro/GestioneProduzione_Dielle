#YMAX=590
#XMAX=830

def TraduciComandi(riga,spostay)
  
  if $nome_file=="StampaPrelievi"
    ymax=590   #x Stampe Orizzontali
  elsif $nome_file=="StampaLaccati"  
    ymax=840   #x Stampe Verticali
  else
    ymax=840   #x Stampe Verticali
  end

  scalax=2.85
  scalay=2.85
  carattere_default=8
  stampa_r=""

   if riga.size > 1   
     #comando=riga.split(" ",3)
     comando_condizione=riga.split("$")
     comando=comando_condizione[0].split(" ",3)
     case comando[0]
     when "LINEA" 
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)
       y=(ymax-(parametri[1].to_f+spostay)*scalay)
       x2=(scalax*parametri[2].to_f)
       y2=(ymax-parametri[3].to_f*scalay)
       return "pdf.stroke_line(#{x},#{y},#{x2},#{y2})" + "\n"
     when "LINEAX" 
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)
       y=(ymax-(parametri[1].to_f+spostay)*scalay)
       x2=(scalax*parametri[2].to_f)
       y2=(ymax-(parametri[3].to_f+spostay)*scalay)
       return "pdf.stroke_line(#{x},#{y},#{x2},#{y2})" + "\n"
     when "RETTANGOLO"
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)
       y=(ymax-(parametri[1].to_f+spostay)*scalay)
       x2=(scalax*parametri[2].to_f)
       y2=(parametri[3].to_f*scalay)
       #puts "[#{x},#{y}],#{x2},#{y2}"
       return "pdf.stroke_rounded_rectangle([#{x},#{y}],#{x2},#{y2},0)" + "\n"
     when "TESTO"
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)
       y=(ymax-(parametri[1].to_f+spostay)*scalay)
       if parametri[2]!=nil
         stampa_r = "pdf.font_size #{parametri[2].to_f}" + "\n"
       else
         stampa_r = "pdf.font_size #{carattere_default.to_f}" + "\n"
       end
       if parametri[3]==nil
         stampa_r = stampa_r + "pdf.draw_text " + comando[2].delete("\n") + ",:at => [#{x}, #{y}], :style => :normal" + "\n"
         return stampa_r
       elsif parametri[3]=="G"
         stampa_r = stampa_r + "pdf.draw_text " + comando[2].delete("\n")  + " ,:at => [#{x}, #{y}], :style => :bold" + "\n"
         return stampa_r
       else
        stampa_r = stampa_r + "pdf.draw_text " + comando[2].delete("\n") + " ,:at => [#{x}, #{y}], :style => :normal" + "\n"
        return stampa_r
       end

     when "CONDIZIONATESTO"
         #puts comando_condizione[1]
         parametri=comando[1].delete("(").delete(")").split(",")
         x=(scalax*parametri[0].to_f)
         y=(ymax-(parametri[1].to_f+spostay)*scalay)

         stampa_r="if " + comando_condizione[1] + "  \n"

         if parametri[2]!=nil
           stampa_r =stampa_r + "pdf.font_size #{parametri[2].to_f}" + "\n"
         else
           stampa_r =stampa_r + "pdf.font_size #{carattere_default.to_f}" + "\n"
         end
         if parametri[3]==nil
           stampa_r = stampa_r + "pdf.draw_text " + comando[2].delete("\n") + ",:at => [#{x}, #{y}], :style => :normal" + "\n" + "end" + "\n"
           return stampa_r
         elsif parametri[3]=="G"
           stampa_r = stampa_r + "pdf.draw_text " + comando[2].delete("\n")  + " ,:at => [#{x}, #{y}], :style => :bold" + "\n"  + "end" + "\n"
           #puts stampa_r x debug
           return stampa_r
         else
          stampa_r = stampa_r + "pdf.draw_text " + comando[2].delete("\n") + " ,:at => [#{x}, #{y}], :style => :normal" + "\n"  + "end" + "\n"
          return stampa_r
         end

     when "TXTBOXED"
         parametri=comando[1].delete("(").delete(")").split(",")
         x=(scalax*parametri[0].to_f)
         y=(ymax-(parametri[1].to_f+spostay)*scalay)
         dimx=parametri[2].to_f
         dimy=parametri[3].to_f
         if parametri[4]!=nil
           stampa_r = "pdf.font_size #{parametri[4].to_f} \n"
         else
           stampa_r = "pdf.font_size #{carattere_default.to_f} \n"
         end
         stampa_r= stampa_r + "pdf.bounding_box([#{x},#{y}], :width => #{dimx}, :height => #{dimy}) do " + "\n"
         stampa_r= stampa_r + "pdf.text " + comando[2].delete("\n") + "\n"
         stampa_r= stampa_r + "end" + "\n"
         return stampa_r
     when "BARCODE39"
         parametri=comando[1].delete("(").delete(")").split(",")
         x=(scalax*parametri[0].to_f)
         y=(ymax-(parametri[1].to_f+spostay)*scalay)
         dimx=parametri[2].to_f
         dimy=parametri[3].to_f
         stampa_r="barcode = Barby::Code39.new("+ comando[2] + ") \n"
         stampa_r= stampa_r  + "pdf.svg barcode.to_svg(:width => #{dimx} ,:height => #{dimy}, :margin => 1), :at => [#{x}, #{y}] " + "\n"
         return stampa_r
     when "IMMAGINE"
         parametri=comando[1].delete("(").delete(")").split(",")
         dimx=parametri[0].to_f
         dimy=parametri[1].to_f
         dimx_img=parametri[2].to_f
         dimy_img=parametri[3].to_f
         x=(scalax*parametri[4].to_f)
         y=(ymax-(parametri[5].to_f+spostay)*scalay)
         stampa_r="begin" + "\n"
         stampa_r=stampa_r + "pdf.bounding_box([#{x},#{y}], :width => #{dimx}, :height => #{dimy}) do " +"\n"
         stampa_r=stampa_r + "pdf.image " + comando[2].delete("\n") + ", width: #{dimx_img}, height: #{dimy_img}, :position => :left " +"\n"
         stampa_r=stampa_r + "end" + "\n"
         stampa_r=stampa_r + "rescue" + "\n"
         stampa_r=stampa_r + "end" + "\n"
         return stampa_r
     end
  end   
  return ""
end

