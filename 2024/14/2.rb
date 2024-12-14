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

  def [](row, column)
    return if row < 0 || column < 0
    @map[row] && @map[row][column]
  end

  def line
    @map.flatten.map do |position|
      if position.size.zero?
        "."
      else
        "#"
      end
    end.join
  end

  def print
    @map.each do |row|
      row.each do |position|
        if position.size.zero?
          Kernel.print(".")
        else
          Kernel.print("#")
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

i = 1

loop do
  map.tick

  if map.line.include?("#########")
    map.print
    puts i
    break
  else
    i += 1
  end
end
