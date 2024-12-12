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

  def initialize(char, plots = [])
    @char = char
    @plots = plots
  end

  def <<(plot)
    @plots << plot
  end

  def area
    @plots.size
  end

  def sides
    top_sides + bottom_sides + left_sides + right_sides
  end

  def price
    area*sides
  end

  private

  def top_sides
    sides = 0

    @plots.group_by(&:row).each_value do |row|
      current_side = false

      row.sort_by(&:column).each do |plot|
        if neighbor(plot, :top)
          current_side = false
        else
          if current_side
            # the fence goes on
          else
            sides += 1
          end

          if neighbor(plot, :right)
            current_side = true
          else
            current_side = false
          end
        end
      end
    end

    sides
  end

  def bottom_sides
    sides = 0

    @plots.group_by(&:row).each_value do |row|
      current_side = false

      row.sort_by(&:column).each do |plot|
        if neighbor(plot, :bottom)
          current_side = false
        else
          if current_side
            # the fence goes on
          else
            sides += 1
          end

          if neighbor(plot, :right)
            current_side = true
          else
            current_side = false
          end
        end
      end
    end

    sides
  end

  def left_sides
    sides = 0

    @plots.group_by(&:column).each_value do |column|
      current_side = false

      column.sort_by(&:row).each do |plot|
        if neighbor(plot, :left)
          current_side = false
        else
          if current_side
            # the fence goes on
          else
            sides += 1
          end

          if neighbor(plot, :bottom)
            current_side = true
          else
            current_side = false
          end
        end
      end
    end

    sides
  end

  def right_sides
    sides = 0

    @plots.group_by(&:column).each_value do |column|
      current_side = false

      column.sort_by(&:row).each do |plot|
        if neighbor(plot, :right)
          current_side = false
        else
          if current_side
            # the fence goes on
          else
            sides += 1
          end

          if neighbor(plot, :bottom)
            current_side = true
          else
            current_side = false
          end
        end
      end
    end

    sides
  end

  def neighbor(plot, direction)
    case direction
    when :top
      @plots.find { |neighbor| neighbor.row == plot.row - 1 && neighbor.column == plot.column }
    when :bottom
      @plots.find { |neighbor| neighbor.row == plot.row + 1 && neighbor.column == plot.column }
    when :left
      @plots.find { |neighbor| neighbor.row == plot.row     && neighbor.column == plot.column - 1 }
    when :right
      @plots.find { |neighbor| neighbor.row == plot.row     && neighbor.column == plot.column + 1 }
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
