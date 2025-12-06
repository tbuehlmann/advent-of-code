input = File.readlines("input.txt", chomp: true)

# Fill empty spaces with x
0.upto(3) do |i|
  input[i].each_char.with_index do |char, index|
    if char == " "
      0.upto(3) do |j|
        next if i == j

        if input[j][index] != " "
          input[i][index] = "x"
          break
        end
      end
    end
  end
end

problems = []

input.map do |line|
  line.split.each_with_index do |char, index|
    problems[index] ||= []

    if char == "+" || char == "*"
      problems[index] << char.to_sym
    else
      problems[index] << char
    end
  end
end

grand_total = problems.sum do |problem|
  *numbers, operator = problem

  numbers[0].size.times.map do |i|
    numbers.map do |number|
      if number[i] == "x"
        nil # vanishes when using #join
      else
        number[i]
      end
    end.join.to_i
  end.inject(&operator)
end

puts grand_total
