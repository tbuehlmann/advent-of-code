input = File.readlines("input.txt", chomp: true)

fresh_ingredients = []

input.each do |line|
  break if line == ""

  if line.include?("-")
    from, to = line.split("-").map(&:to_i)
    fresh_ingredients << (from..to)
  end
end

nothing_merged = false

until nothing_merged
  nothing_merged = true
  fresh_ingredients.tap(&:compact!).tap(&:uniq!)

  0.upto(fresh_ingredients.size-1) do |i|
    0.upto(fresh_ingredients.size-1) do |j|
      next if i == j
      a = fresh_ingredients[i]
      b = fresh_ingredients[j]
      next if a.nil? || b.nil?

      if a.overlap?(b)
        fresh_ingredients[i] = (([a.min, b.min].min)..([a.max, b.max].max))
        fresh_ingredients[j] = nil
        nothing_merged = false
      end
    end
  end
end

puts fresh_ingredients.sum(&:size)
