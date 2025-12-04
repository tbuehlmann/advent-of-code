input = File.readlines("input.txt", chomp: true)

def input.get(row, column)
  return nil if row < 0 || column < 0
  return nil if row > 134 || column > 134

  self[row][column]
end

paper_rolls_removed = 0
paper_roll_removed = true

until paper_roll_removed == false
  paper_roll_removed = false

  0.upto(134) do |row|
    0.upto(134) do |column|
      if input.get(row, column) == "@"
        neighbors = [
          # above
          input.get(row-1, column-1),
          input.get(row-1, column+0),
          input.get(row-1, column+1),

          # left
          input.get(row, column-1),

          # right
          input.get(row, column+1),

          # below
          input.get(row+1, column-1),
          input.get(row+1, column+0),
          input.get(row+1, column+1)
        ]

        if neighbors.count("@") < 4
          input[row][column] = "x"
          paper_rolls_removed += 1
          paper_roll_removed = true
        end
      end
    end
  end
end

puts paper_rolls_removed
