input = File.readlines("input.txt").map(&:strip)

left_list = []
right_map = Hash.new { |hash, key| hash[key] = 0 }

input.each do |line|
  left, right = line.split

  left_list << left.to_i
  right_map[right.to_i] += 1
end

similarity = 0

left_list.each do |number|
  similarity += number*right_map[number]
end

puts similarity
