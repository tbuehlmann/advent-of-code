input = File.readlines("input.txt", chomp: true)

sum = 0

# Idea:
#   1. Find largest number B
#   2. Find largest number A left of B
#   3. Find largest number C right of B
#   4. Pick larger number of AB and BC
input.each do |bank|
  batteries = bank.chars.map(&:to_i)

  largest_battery = batteries.max
  largest_battery_index = batteries.index(largest_battery)

  if largest_battery_index == 0
    sum += largest_battery*10 + batteries[1..-1].max
  elsif largest_battery_index == 99
    sum += batteries[0..-2].max*10 + largest_battery
  else
    left_battery = batteries[0..largest_battery_index-1].max
    right_battery = batteries[largest_battery_index+1..99].max

    sum += [
      left_battery*10 + largest_battery,
      largest_battery*10 + right_battery,
    ].max
  end
end

puts sum
