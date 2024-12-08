input = File.readlines("input.txt").map(&:strip).map(&:chars)

class Antenna
  attr_reader :char, :position

  def initialize(char:, position:)
    @position = position
    @char = char
  end

  def inspect
    "#<Antenna char=#{@char.inspect} row=#{@position.row} col=#{@position.column}>"
  end
end

class Antinode
  def initialize(position:)
    @position = position
    @antennas = Set.new
  end

  def inspect
    "#<Antinode row=#{@position.row} col=#{@position.column}>"
  end
end

class Position
  attr_reader :row, :column
  attr_accessor :antenna

  def initialize(row, column)
    @row = row
    @column = column
    @antinodes = Set.new
  end

  def antinodes
    @antinodes ||= Set.new
  end

  def print
    if antenna
      Kernel.print(antenna.char)
    elsif antinodes.any?
      Kernel.print("#")
    else
      Kernel.print(".")
    end
  end

  def inspect
    "#<Position row=#{@row} col=#{@column} antenna=#{@antenna.inspect}>"
  end
end

class Map
  def self.for_input(input)
    map = []

    input.each_with_index do |row, row_index|
      map[row_index] = []

      row.each_with_index do |char, column_index|
        position = Position.new(row_index, column_index)

        if char =~ /\w/
          antenna = Antenna.new(char: char, position: position)
          position.antenna = antenna
        end

        map[row_index] << position
      end
    end

    new(map)
  end

  def initialize(map)
    @map = map
  end

  def calculate_antinodes
    antennas = positions.map(&:antenna).compact

    antennas.group_by(&:char).each_value do |group|
      group.combination(2).each do |a, b|
        row_diff = a.position.row - b.position.row
        column_diff = a.position.column - b.position.column

        possible_antinode_a_1 = self[a.position.row + row_diff, a.position.column + column_diff]
        possible_antinode_a_2 = self[a.position.row - row_diff, a.position.column - column_diff]
        possible_antinode_b_1 = self[b.position.row + row_diff, b.position.column + column_diff]
        possible_antinode_b_2 = self[b.position.row - row_diff, b.position.column - column_diff]

        if possible_antinode_a_1 && possible_antinode_a_1 != b.position
          antinode = Antinode.new(position: possible_antinode_a_1)
          possible_antinode_a_1.antinodes << antinode
        end

        if possible_antinode_a_2 && possible_antinode_a_2 != b.position
          antinode = Antinode.new(position: possible_antinode_a_2)
          possible_antinode_a_2.antinodes << antinode
        end

        if possible_antinode_b_1 && possible_antinode_b_1 != a.position
          antinode = Antinode.new(position: possible_antinode_b_1)
          possible_antinode_b_1.antinodes << antinode
        end

        if possible_antinode_b_2 && possible_antinode_b_2 != a.position
          antinode = Antinode.new(position: possible_antinode_b_2)
          possible_antinode_b_2.antinodes << antinode
        end
      end
    end
  end

  def [](row, column)
    return if row < 0 || column < 0
    @map[row] && @map[row][column]
  end

  def positions
    @map.flatten
  end

  def print
    @map.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        @map[row_index][column_index].print
      end

      puts
    end

    puts
    puts
  end
end

map = Map.for_input(input)
map.calculate_antinodes

puts map.positions.count { |position| position.antinodes.any? }
