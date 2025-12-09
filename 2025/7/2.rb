input = File.readlines("input.txt", chomp: true)

beams = Hash.new(0)

start = input[0].index("S")
beams[start] += 1

input.each.with_index do |line, row|
  line.each_char.with_index do |char, column|
    if char == "^" && beams[column] > 0
      beams[column-1] += beams[column]
      beams[column+1] += beams[column]
      beams[column] = 0
    end
  end
end

puts beams.values.sum
