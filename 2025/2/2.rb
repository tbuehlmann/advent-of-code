input = File.read("input.txt").strip.split(",")

sum = 0

# Slow solution
# factors = Hash.new { |hash, key| hash[key] = (1..key).select { |i| key % i == 0 } - [key] }

# input.each do |range|
#   from, to = range.split("-")

#   from.upto(to) do |id|
#     number_of_digits = id.length

#     factors[number_of_digits].each do |factor|
#       slices = id.chars.each_slice(factor).map(&:join)

#       if slices.uniq.length == 1
#         sum += id.to_i
#         break
#       end
#     end
#   end
# end

input.each do |range|
  from, to = range.split("-")

  from.upto(to) do |id|
    if id =~ /^(\d+)\1+$/
      sum += id.to_i
    end
  end
end

puts sum
