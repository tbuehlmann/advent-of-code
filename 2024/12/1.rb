input = File.readlines("input.txt").map(&:strip).map(&:chars)

class Plot
  attr_reader :row, :column, :char
  attr_accessor :region

  def initialize(row, column, char)
    @row = row
    @column = column
    @char = char
    @region = nil
  end
end

class Region
  attr_reader :char, :plots

  def initialize(char, plots = Set.new)
    @char = char
    @plots = plots
  end

  def <<(plot)
    @plots << plot
  end

  def area
    @plots.size
  end

  def diameter
    plots.sum do |plot|
      4 - neighbors_of(plot).size
    end
  end

  def price
    area*diameter
  end

  private

  def neighbors_of(plot)
    @plots.select do |potential_neighbor|
      (potential_neighbor.row == plot.row + 1 && potential_neighbor.column == plot.column) ||
      (potential_neighbor.row == plot.row - 1 && potential_neighbor.column == plot.column) ||
      (potential_neighbor.row == plot.row     && potential_neighbor.column == plot.column + 1) ||
      (potential_neighbor.row == plot.row     && potential_neighbor.column == plot.column - 1)
    end
  end
end

class Farm
  def self.for_input(input)
    map = []

    input.each_with_index do |row, row_index|
      map[row_index] = []

      row.each_with_index do |char, column_index|
        plot = Plot.new(row_index, column_index, char)
        map[row_index] << plot
      end
    end

    new(map)
  end

  attr_reader :regions

  def initialize(map)
    @map = map
    @regions = []
    populate_regions!
  end

  private

  def populate_regions!
    @map.each_with_index do |row|
      row.each_with_index do |plot|
        unless plot.region
          @regions << region = Region.new(plot.char)
          populate_region(region, plot)
        end
      end
    end
  end

  def populate_region(region, plot)
    plot.region = region
    region.plots << plot

    adjacent_plots_of(plot).each do |neighbor|
      if neighbor.char == plot.char && !neighbor.region
        populate_region(region, neighbor)
      end
    end
  end

  def adjacent_plots_of(plot)
    top = position(plot.row - 1, plot.column)
    right = position(plot.row, plot.column + 1)
    bottom = position(plot.row + 1, plot.column)
    left = position(plot.row, plot.column - 1)

    [top, right, bottom, left].select(&:itself)
  end

  def position(row, column)
    return if row < 0 || column < 0
    @map[row] && @map[row][column]
  end
end

farm = Farm.for_input(input)
puts farm.regions.sum(&:price)
