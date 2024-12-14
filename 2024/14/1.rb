input = File.readlines("input.txt").map(&:strip)

class Robot
  attr_reader :vx, :vy

  def initialize(vx, vy)
    @vx = vx
    @vy = vy
  end
end

class Map
  def initialize(rows:, columns:)
    @map = rows.times.map do
      columns.times.map { Set.new }
    end
  end

  def tick
    robots.each do |robot, row, column|
      new_row = (row + robot.vy) % @map.size
      new_column = (column + robot.vx) % @map[0].size

      self[row, column].delete(robot)
      self[new_row, new_column] << robot
    end
  end

  def robots
    @map.flat_map.with_index do |row, row_index|
      row.flat_map.with_index do |position, column_index|
        position.map do |robot|
          [robot, row_index, column_index]
        end
      end
    end
  end

  def robots_per_quadrant
    rows = @map.size
    columns = @map[0].size

    Hash.new { |hash, key| hash[key] = 0 }.tap do |robots_per_quadrant|
      @map.each_with_index do |row, row_index|
        row.each_with_index do |robots, column_index|
          if row_index < rows/2
            # top
            if column_index < columns/2
              # left
              robots_per_quadrant[:top_left] += robots.size
            elsif column_index > columns/2
              # right
              robots_per_quadrant[:top_right] += robots.size
            end
          elsif row_index > rows/2
            # bottom
            if column_index < columns/2
              # left
              robots_per_quadrant[:bottom_left] += robots.size
            elsif column_index > columns/2
              # right
              robots_per_quadrant[:bottom_right] += robots.size
            end
          end
        end
      end
    end
  end

  def [](row, column)
    return if row < 0 || column < 0
    @map[row] && @map[row][column]
  end

  def print
    @map.each do |row|
      row.each do |position|
        if position.size.zero?
          Kernel.print(".")
        else
          Kernel.print(position.size)
        end
      end

      puts
    end
  end
end

map = Map.new(rows: 103, columns: 101)

input.each do |line|
  column, row, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  map[row, column] << Robot.new(vx, vy)
end

100.times { map.tick }
puts map.robots_per_quadrant.values.inject(:*)
