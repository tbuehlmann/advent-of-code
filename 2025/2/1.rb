input = File.read("input.txt").strip.split(",")

sum = 0

input.each do |range|
  from, to = range.split("-")

  from.upto(to) do |id|
    number_of_digits = id.length

    if number_of_digits.even?
      first_part = id[0..number_of_digits/2 - 1]
      second_part = id[number_of_digits/2..number_of_digits]

      if first_part == second_part
        sum += id.to_i
      end
    end
  end
end

puts sum
