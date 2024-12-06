input = File.read("input.txt").split.map(&:chars)

class Position
  attr_reader :row, :column

  def initialize(row, column, obstacle: false, visited: false)
    @row = row
    @column = column
    @obstacle = obstacle
    @visited = visited
  end

  def visited!
    @visited = true
  end

  def obstacle?
    @obstacle
  end

  def visited?
    @visited
  end

  def print
    if obstacle?
      Kernel.print("#")
    else
      Kernel.print(".")
    end
  end
end

class Guard
  attr_reader :facing
  attr_accessor :position

  def initialize(position:, facing:)
    @position = position
    @facing = facing
  end

  def turn
    case @facing
    when "up"
      @facing = "right"
    when "right"
      @facing = "down"
    when "down"
      @facing = "left"
    when "left"
      @facing = "up"
    end
  end

  def print
    case @facing
    when "up"
      Kernel.print("^")
    when "right"
      Kernel.print(">")
    when "down"
      Kernel.print("v")
    when "left"
      Kernel.print("<")
    end
  end
end

class Lab
  def self.for_input(input)
    map = []
    guard = nil

    input.each_with_index do |row, row_index|
      map[row_index] = []

      row.each_with_index do |column, column_index|
        case column
        when "."
          map[row_index][column_index] = Position.new(row_index, column_index)
        when "#"
          map[row_index][column_index] = Position.new(row_index, column_index, obstacle: true)
        when "^"
          map[row_index][column_index] = Position.new(row_index, column_index, visited: true)
          guard = Guard.new(position: map[row_index][column_index], facing: "up")
        end
      end
    end

    new(map, guard)
  end

  def initialize(map, guard)
    @map = map
    @guard = guard
  end

  def [](row, column)
    @map[row][column]
  end

  def positions
    @map.flatten
  end

  def step
    if guard_looks_at_out_of_bounds?
      false
    elsif guard_looks_at_obstacle?
      @guard.turn
      true
    else
      position = guard_looking_at_position
      @guard.position = position
      position.visited!
      true
    end
  end

  def print
    @map.each_with_index do |row, row_index|
      Kernel.print(" ")
      Kernel.print(" ")

      row.each_with_index do |column, column_index|
        position = @map[row_index][column_index]

        if position == @guard.position
          @guard.print
        else
          position.print
        end
      end

      puts
    end

    nil
  end

  private

  def guard_looking_at_position
    case @guard.facing
    when "up"
      row, column = @guard.position.row - 1, @guard.position.column
    when "right"
      row, column = @guard.position.row, @guard.position.column + 1
    when "down"
      row, column = @guard.position.row + 1, @guard.position.column
    when "left"
      row, column = @guard.position.row, @guard.position.column - 1
    end

    if row.between?(0, @map.size - 1) && column.between?(0, @map[0].size - 1)
      @map[row][column]
    else
      nil # out of bounds
    end
  end

  def guard_looks_at_out_of_bounds?
    guard_looking_at_position.nil?
  end

  def guard_looks_at_obstacle?
    guard_looking_at_position.obstacle?
  end
end

lab = Lab.for_input(input)

loop do
  break unless lab.step
end

puts lab.positions.count(&:visited?)
