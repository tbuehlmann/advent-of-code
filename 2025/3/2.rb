input = File.readlines("input.txt", chomp: true)

sum = 0

input.each do |bank|
  batteries = bank.chars.map(&:to_i)
  joltage = []
  from = 0
  to = -12

  12.times do
    range = batteries[from..to]

    largest_battery = range.max
    largest_battery_index = range.index(largest_battery)

    joltage << largest_battery
    from += largest_battery_index + 1
    to += 1
  end

  sum += joltage.join.to_i
end

puts sum
