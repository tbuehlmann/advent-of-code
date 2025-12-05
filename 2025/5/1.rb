input = File.readlines("input.txt", chomp: true)

fresh_ingredients = []
ingredients = []

input.each do |line|
  next if line == ""

  if line.include?("-")
    from, to = line.split("-").map(&:to_i)
    fresh_ingredients << (from..to)
  else
    ingredients << line.to_i
  end
end

sum = ingredients.count do |ingredient|
  fresh_ingredients.any? { it.include?(ingredient) }
end

puts sum
