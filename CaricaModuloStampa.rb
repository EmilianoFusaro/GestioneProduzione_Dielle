#YMAX=590
#XMAX=830

def TraduciComandi(riga,sposta_x,sposta_y)

  ymax=590
  scalax=2.85
  scalay=2.85
  carattere_default=8
  carattere_code=6
  #sposta_x=0
  #sposta_y=0
  stampa_r=""
  
   if riga.size > 1
     comando_condizione=riga.split("$")
     comando=comando_condizione[0].split(" ",3)
     case comando[0]
     when "LINEA"
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)+sposta_x
       y=(ymax-parametri[1].to_f*scalay)+sposta_y
       x2=(scalax*parametri[2].to_f)+sposta_x
       y2=(ymax-parametri[3].to_f*scalay)+sposta_y
       return "pdf.stroke_line(#{x},#{y},#{x2},#{y2})" + "\n"
     when "RETTANGOLO"
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)+sposta_x
       y=(ymax-parametri[1].to_f*scalay)+sposta_y
       x2=(scalax*parametri[2].to_f)
       y2=(ymax-parametri[3].to_f*scalay)
       return "pdf.stroke_rounded_rectangle([#{x},#{y}],#{x2},#{y2},0)" + "\n"
     when "TESTO"
       parametri=comando[1].delete("(").delete(")").split(",")
       x=(scalax*parametri[0].to_f)+sposta_x
       y=(ymax-parametri[1].to_f*scalay)+sposta_y
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
         x=(scalax*parametri[0].to_f)+sposta_x
         y=(ymax-parametri[1].to_f*scalay)+sposta_y

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
         x=(scalax*parametri[0].to_f)+sposta_x
         y=(ymax-parametri[1].to_f*scalay)+sposta_y
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
         x=(scalax*parametri[0].to_f)+sposta_x
         y=(ymax-parametri[1].to_f*scalay)+sposta_y
         dimx=parametri[2].to_f
         dimy=parametri[3].to_f
         comando=riga.split(" ",4)

           if comando[3] !=nil and comando[3] !=""      #---valuta una condizione prima di stampare
              stampa_r= "if (" + comando[3] + ")  \n"
              stampa_r=stampa_r  + "barcode = Barby::Code39.new("+ comando[2] + ") \n"
              #la prima dimensione del svg non viene presa in toto la seconda del pdf è perfetta
              #stampa_r=stampa_r  + "pdf.svg barcode.to_svg(:width => #{dimx} ,:height => #{dimy}, :margin => 6), :at => [#{x}, #{y}]  ,:width => #{dimx} ,:height=>#{dimy}" + "\n"
              stampa_r=stampa_r  + "pdf.svg barcode.to_svg(:width => #{dimx} ,:height => #{dimy}, :margin => 0), :at => [#{x}, #{y}]  ,:width => #{dimx} ,:height=>#{dimy}" + "\n"
              stampa_r=stampa_r  + "end \n"
              return stampa_r
           else                                         #---NON valuta una condizione prima di stampare
             stampa_r= "barcode = Barby::Code39.new("+ comando[2] + ") \n"
             #la prima dimensione del svg non viene presa in toto la seconda del pdf è perfetta
             #stampa_r= stampa_r  + "pdf.svg barcode.to_svg(:width => #{dimx} ,:height => #{dimy}, :margin => 6), :at => [#{x}, #{y}]  ,:width => #{dimx} ,:height=>#{dimy}" + "\n"
             stampa_r= stampa_r  + "pdf.svg barcode.to_svg(:width => #{dimx} ,:height => #{dimy}, :margin => 0), :at => [#{x}, #{y}]  ,:width => #{dimx} ,:height=>#{dimy}" + "\n"
             return stampa_r
           end

     when "IMMAGINE"
         parametri=comando[1].delete("(").delete(")").split(",")
         dimx=parametri[0].to_f
         dimy=parametri[1].to_f
         dimx_img=parametri[2].to_f
         dimy_img=parametri[3].to_f
         x=(scalax*parametri[4].to_f)+sposta_x
         y=(ymax-parametri[5].to_f*scalay)+sposta_y
         comando=riga.split(" ",4)
         if comando[3] !=nil and comando[3] !=""
            stampa_r="if " + comando[3] + "  \n"
            stampa_r=stampa_r + "begin" + "\n"
            stampa_r=stampa_r + "pdf.bounding_box([#{x},#{y}], :width => #{dimx}, :height => #{dimy}) do " +"\n"
            stampa_r=stampa_r + "pdf.image " + comando[2].delete("\n") + ", width: #{dimx_img}, height: #{dimy_img}, :position => :left " +"\n"
            stampa_r=stampa_r + "end" + "\n"
            stampa_r=stampa_r + "rescue" + "\n"
            stampa_r=stampa_r + "end" + "\n"
            stampa_r=stampa_r + "end" + "\n"
            return stampa_r
         else
            stampa_r="begin" + "\n"
            stampa_r=stampa_r + "pdf.bounding_box([#{x},#{y}], :width => #{dimx}, :height => #{dimy}) do " +"\n"
            stampa_r=stampa_r + "pdf.image " + comando[2].delete("\n") + ", width: #{dimx_img}, height: #{dimy_img}, :position => :left " +"\n"
            stampa_r=stampa_r + "end" + "\n"
            stampa_r=stampa_r + "rescue" + "\n"
            stampa_r=stampa_r + "end" + "\n"
            return stampa_r
         end
     end
  end
  return ""
end

def CaricaModuloStampa(modulostampa,sposta_x,sposta_y)

  stampa=""

   File.open(modulostampa,"r") do |myfile|
   myfile.each {|riga|
   stampa = stampa + TraduciComandi(riga,sposta_x,sposta_y)
   }
   end

   return stampa

end
