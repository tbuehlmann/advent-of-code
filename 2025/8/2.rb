input = File.readlines("input.txt", chomp: true)

junction_boxes = input.map do |line|
  x, y, z = line.split(",").map(&:to_i)
  {x: x, y: y, z: z}
end

distances = junction_boxes.combination(2).map do |a, b|
  [a, b, Math.sqrt((a[:x] - b[:x])**2 + (a[:y] - b[:y])**2 + (a[:z] - b[:z])**2)]
end

circuits = junction_boxes.map { [it].to_set }

distances.sort_by(&:last).each do |distance|
  a = distance[0]
  b = distance[1]

  circuit_a = circuits.find { it.include?(a) }
  circuit_b = circuits.find { it.include?(b) }

  if circuit_a == circuit_b
    # nothing happens
  else
    # merge circuits
    circuits.delete(circuit_a)
    circuits.delete(circuit_b)
    circuits << circuit_a + circuit_b
  end

  if circuits.size == 1
    puts a[:x]*b[:x]
    break
  end
end
