a=nil
t1 = Time.now
for i in 0..1000000
  #if a!=nil
  #if !!a
  #end	
  puts i
end
t2 = Time.now

puts "Valore Iniziale:#{t1.sec}.#{t1.usec}"
puts "Valore Finale  :#{t2.sec}.#{t2.usec}"

