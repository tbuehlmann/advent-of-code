input = File.readlines("input.txt").map(&:strip)

left_list = []
right_list = []

input.each do |line|
  left, right = line.split

  left_list << left.to_i
  right_list << right.to_i
end

left_list.sort!
right_list.sort!

distance = 0

left_list.each_with_index do |number, index|
  other = right_list[index]

  distance += (number - other).abs
end

puts distance
