input = File.readlines("input.txt").map(&:strip).map(&:chars)

class Position
  attr_reader :row, :column, :height

  def initialize(row, column, height)
    @row = row
    @column = column
    @height = height
  end

  def to_s
    "#<Pos #{@row}:#{@column} height=#{@height}>"
  end

  def inspect
    to_s
  end
end

class Node
  attr_reader :parent, :element, :children

  def initialize(element, parent: nil)
    @parent = parent
    @element = element
    @children = []
  end

  def leaves
    if @children.empty?
      self
    else
      @children.flat_map(&:leaves)
    end
  end

  def paths
    return [[self]] if leaves == self

    leaves.map do |node|
      chain = [node]

      while node = node.parent
        chain.unshift(node)
        break if node == self
      end

      chain
    end
  end

  def <<(element)
    @children << element
  end
end

class Map
  def self.for_input(input)
    map = []

    input.each_with_index do |row, row_index|
      map[row_index] = []

      row.each_with_index do |column, column_index|
        height = column == "." ? -1 : column.to_i
        position = Position.new(row_index, column_index, height)
        map[row_index] << position
      end
    end

    new(map)
  end

  def initialize(map)
    @map = map
  end

  def trails
    trailheads.each_with_object({}) do |trailhead, hash|
      root = Node.new(trailhead)
      populate_paths_for(root)

      hash[trailhead] = root.paths.map do |path|
        path.map(&:element)
      end

      hash[trailhead].select! { |trail| trail.last.height == 9 }
    end
  end

  def populate_paths_for(parent)
    return if parent.element.height == 9

    adjacent_positions_with_height_for(parent.element, parent.element.height + 1).each do |pos|
      parent << Node.new(pos, parent: parent)
    end

    parent.children.each do |child|
      populate_paths_for(child)
    end
  end

  def adjacent_positions_with_height_for(position, height)
    top = position(position.row - 1, position.column)
    right = position(position.row, position.column + 1)
    bottom = position(position.row + 1, position.column)
    left = position(position.row, position.column - 1)

    [top, right, bottom, left].select do |pos|
      pos && pos.height == height
    end
  end

  def trailheads
    @map.flatten.select { |position| position.height == 0}
  end

  def position(row, column)
    return if row < 0 || column < 0
    @map[row] && @map[row][column]
  end

  def positions
    @map.flat_map
  end

  def print
    @map.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        height = @map[row_index][column_index].height

        if height < 0
          Kernel.print(".")
        else
          Kernel.print(height)
        end
      end

      puts
    end

    puts
    puts
  end
end

map = Map.for_input(input)
puts map.trails.sum { |_trailhead, trails| trails.count }
