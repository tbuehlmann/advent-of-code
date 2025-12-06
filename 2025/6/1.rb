input = File.readlines("input.txt", chomp: true)

problems = []

input.map do |line|
  line.split.each_with_index do |char, index|
    problems[index] ||= []

    if char == "+" || char == "*"
      problems[index] << char.to_sym
    else
      problems[index] << char.to_i
    end
  end
end

grand_total = problems.sum do |problem|
  *numbers, operator = problem
  numbers.inject(&operator)
end

puts grand_total
