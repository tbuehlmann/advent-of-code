input = File.readlines("input.txt", chomp: true)

beams_split = 0

input.each.with_index do |line, row|
  next if row == 0

  line.each_char.with_index do |char, column|
    case char
    when "^"
      above = input[row-1][column]

      if above == "|"
        input[row][column-1] = "|"
        input[row][column+1] = "|"

        beams_split += 1
      end
    when "."
      above = input[row-1][column]

      if above == "|" || above == "S"
        input[row][column] = "|"
      end
    end
  end
end

puts beams_split
