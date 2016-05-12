start= Time.now

# Code for bubble sort
NUM_STUDENTS = 35
# Max grade of 100%
MAX_GRADE = 100
num_compare = 0
arr = Array.new(NUM_STUDENTS)

# Randomly put some final exam grades into arr
for i in (0..NUM_STUDENTS - 1)
  arr[i] = rand(MAX_GRADE + 1)
end

# Output randomly generated array
#puts "Input array:"
#for i in (0..NUM_STUDENTS - 1)
#  puts "arr[" + i.to_s + "] ==> " + arr[i].to_s
#end

# Now let's use bubble sort. Swap pairs iteratively as we loop through the
# array from the beginning of the array to the second-to-last value
for i in (0..NUM_STUDENTS - 2)
  # From arr[i + 1] to the end of the array
  for j in ((i + 1)..NUM_STUDENTS - 1)
    num_compare = num_compare + 1
    # If the first value is greater than the second value, swap them
    if (arr[i] > arr[j])
      temp = arr[j]
      arr[j] = arr[i]
      arr[i] = temp
    end
    puts arr.join("*")
  end
end

# Now output the sorted array
#puts "Sorted array:"
#for i in (0..NUM_STUDENTS - 1)
#  puts "arr[" + i.to_s + "] ==> " + arr[i].to_s
#end
#puts "Number of Comparisons ==> " + num_compare.to_s


finish  = Time.now
diff = finish - start
puts "Tempo Di Esecuzione #{diff}"