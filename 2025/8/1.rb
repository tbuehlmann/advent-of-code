input = File.readlines("input.txt", chomp: true)

junction_boxes = input.map do |line|
  x, y, z = line.split(",").map(&:to_i)
  {x: x, y: y, z: z}
end

distances = junction_boxes.combination(2).map do |a, b|
  [a, b, Math.sqrt((a[:x] - b[:x])**2 + (a[:y] - b[:y])**2 + (a[:z] - b[:z])**2)]
end

circuits = []

distances.sort_by(&:last).first(1000).each do |distance|
  a = distance[0]
  b = distance[1]

  circuit_a = circuits.find { it.include?(a) }
  circuit_b = circuits.find { it.include?(b) }

  if circuit_a && circuit_b
    if circuit_a == circuit_b
      # nothing happens
    else
      # merge circuits
      circuits.delete(circuit_a)
      circuits.delete(circuit_b)
      circuits << circuit_a + circuit_b
    end
  elsif circuit_a
    circuit_a << b
  elsif circuit_b
    circuit_b << a
  else
    circuits << [a, b].to_set
  end
end

puts circuits.map(&:count).sort.last(3).inject(:*)
