input = File.readlines("input.txt").map(&:strip)

position = 50
zeros_encountered = 0

input.each do |rotation|
  direction = rotation[0]
  clicks = rotation[1..-1].to_i

  case direction
  when "R"
    position += clicks
  when "L"
    position -= clicks
  end

  position = position % 100

  zeros_encountered += 1 if position.zero?
end

puts zeros_encountered
