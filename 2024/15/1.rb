input = File.readlines("input.txt").map(&:strip).map(&:chars)

class Map
  def initialize(map, moves)
    @map = map
    @moves = moves
  end

  def move
    @moves.each do |direction|
      robot_row, robot_column = robot
      target_row, target_column = neighbor(robot_row, robot_column, direction)
      target = @map[target_row][target_column]

      case target
      when "."
        @map[target_row][target_column] = "@"
        @map[robot_row][robot_column] = "."
      when "#"
        # Wall
      when "O"
        positions = boxes_until_wall_or_floor(target_row, target_column, direction)
        last_row, last_column, last_char = positions.last

        if last_char == "."
          @map[target_row][target_column] = "@"
          @map[robot_row][robot_column] = "."
          @map[last_row][last_column] = "O"
        end
      end
    end
  end

  def neighbor(row, column, direction)
    case direction
    when "^"
      [row-1, column]
    when ">"
      [row,   column+1]
    when "v"
      [row+1, column]
    when "<"
      [row,   column-1]
    end
  end

  def boxes_until_wall_or_floor(row, column, direction)
    char = @map[row][column]

    if char == "O"
      neighbor_row, neighbor_column = neighbor(row, column, direction)
      [[row, column, char]] + boxes_until_wall_or_floor(neighbor_row, neighbor_column, direction)
    else
      [[row, column, char]]
    end
  end

  def gps
    @map.flat_map.with_index do |row, row_index|
      row.map.with_index do |position, column_index|
        if position == "O"
          100*row_index + column_index
        end
      end
    end.compact
  end

  def robot
    @map.each_with_index do |row, row_index|
      row.each_with_index do |position, column_index|
        return [row_index, column_index] if position == "@"
      end
    end
  end

  def print
    @map.each do |row|
      row.each do |position|
        Kernel.print(position)
      end

      puts
    end
  end
end

rows = input.select { |chars| chars[0] == "#" }
moves = input.select { |chars| chars[0] != "#" && chars.any? }.flatten

map = Map.new(rows, moves)
map.move

puts map.gps.sum
