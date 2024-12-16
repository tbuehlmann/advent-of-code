input = File.readlines("input.txt").map(&:strip).map(&:chars)

class Map
  def initialize(map, moves)
    @map = map
    @moves = moves
  end

  def move
    @moves.each_with_index do |direction,i|
      robot_row, robot_column = robot
      target_row, target_column = neighbor(robot_row, robot_column, direction)
      target = @map[target_row][target_column]

      case target
      when "."
        @map[target_row][target_column] = "@"
        @map[robot_row][robot_column] = "."
      when "#"
        # Wall
      when "[", "]"
        if direction == "<" || direction == ">"
          positions = boxes_until_wall_or_floor(target_row, target_column, direction)
          last_row, last_column, last_char = positions.last

          if last_char == "."
            positions.each do |row, column, char|
              @map[row][column] = {"[" => "]", "]" => "[", "." => direction == "<" ? "[" : "]"}[char]
            end

            @map[robot_row][robot_column] = "."
            @map[target_row][target_column] = "@"
          end
        elsif direction == "^"
          box_start, box_end = if target == "["
            [[target_row, target_column], [target_row, target_column+1]]
          else
            [[target_row, target_column-1], [target_row, target_column]]
          end

          catch(:wall_hit) do
            boxes = boxes_until_wall_or_floor2(box_start, box_end, direction)
            boxes.sort_by! { |b| b[0][0] }

            boxes.each do |bs, be|
              @map[bs[0]-1][bs[1]] = "["
              @map[be[0]-1][be[1]] = "]"
              @map[bs[0]  ][bs[1]] = "."
              @map[be[0]  ][be[1]] = "."
            end

            @map[robot_row][robot_column] = "."
            @map[target_row][target_column] = "@"
          end
        elsif direction == "v"
          box_start, box_end = if target == "["
            [[target_row, target_column], [target_row, target_column+1]]
          else
            [[target_row, target_column-1], [target_row, target_column]]
          end

          catch(:wall_hit) do
            boxes = boxes_until_wall_or_floor2(box_start, box_end, direction)
            boxes.sort_by! { |b| b[0][0] }

            boxes.reverse_each do |bs, be|
              @map[bs[0]+1][bs[1]] = "["
              @map[be[0]+1][be[1]] = "]"
              @map[bs[0]  ][bs[1]] = "."
              @map[be[0]  ][be[1]] = "."
            end

            @map[robot_row][robot_column] = "."
            @map[target_row][target_column] = "@"
          end
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

  def boxes_until_wall_or_floor2(box_start, box_end, direction)
    neighbor_row, neighbor_column = neighbor(box_start[0], box_start[1], direction)
    throw :wall_hit if @map[neighbor_row][neighbor_column] == "#"

    neighbor_row, neighbor_column = neighbor(box_end[0], box_end[1], direction)
    throw :wall_hit if @map[neighbor_row][neighbor_column] == "#"

    neighbor_boxes = []

    r,c = neighbor(box_start[0], box_start[1], direction)

    if @map[r][c] == "]"
      # top/bottom left box
      neighbor_boxes << [[r,c-1], [r,c]]
    elsif @map[r][c] == "["
      # top/bottom
      neighbor_boxes << [[r,c], [r,c+1]]
    end

    r,c = neighbor(box_end[0], box_end[1], direction)

    if @map[r][c] == "["
      # top/bottom right
      neighbor_boxes << [[r,c], [r,c+1]]
    end

    if neighbor_boxes.any?
      [[box_start, box_end]] + neighbor_boxes.flat_map { |bs, be| boxes_until_wall_or_floor2(bs, be, direction) }
    else
      [[box_start, box_end]]
    end
  end

  def boxes_until_wall_or_floor(row, column, direction)
    char = @map[row][column]

    if char == "[" || char == "]"
      neighbor_row, neighbor_column = neighbor(row, column, direction)
      [[row, column, char]] + boxes_until_wall_or_floor(neighbor_row, neighbor_column, direction)
    else
      [[row, column, char]]
    end
  end

  def gps
    @map.flat_map.with_index do |row, row_index|
      row.map.with_index do |position, column_index|
        if position == "["
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

twice = {"#" => "##", "O" => "[]", "." => "..", "@" => "@."}
rows = input.select { |chars| chars[0] == "#" }.map { |row| row.flat_map { |char| twice[char].chars } }
moves = input.select { |chars| chars[0] != "#" && chars.any? }.flatten

map = Map.new(rows, moves)
map.move

puts map.gps.sum
