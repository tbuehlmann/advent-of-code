input = File.read("input.txt").strip.split.map(&:to_i)

25.times do
  input.each_with_index do |number, index|
    input[index] = if number.zero?
      1
    elsif (digits = number.to_s.chars).size.even?
      one = digits[0..digits.size/2 - 1].join.to_i
      two = digits[digits.size/2..-1].join.to_i
      [one, two]
    else
      number*2024
    end
  end

  input.flatten!
end

puts input.size
