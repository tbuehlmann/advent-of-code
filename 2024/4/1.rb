input = File.read("input.txt").strip.split.map(&:chars)

class Board
  def initialize(input)
    @input = input
    @rows_count = input.size
    @columns_count = input[0].size
  end

  def [](row, column)
    @input[row][column] if row.between?(0, @rows_count-1) && column.between?(0, @columns_count-1)
  end

  def positions_starting_xmas
    positions = []

    @rows_count.times do |row|
      @columns_count.times do |column|
        xmases = xmases_started_by(row, column)
        positions.concat(xmases)
      end
    end

    positions
  end

  private

  def xmases_started_by(row, column)
    if self[row, column] == "X"
      horizontal_xmases(row, column) + vertical_xmases(row, column) + diagonal_xmases(row, column)
    else
      []
    end
  end

  def horizontal_xmases(row, column)
    xmases = []

    # Forwards
    if self[row, column+1] == "M" && self[row, column+2] == "A" && self[row, column+3] == "S"
      xmases << [row, column]
    end

    # Backwards
    if self[row, column-1] == "M" && self[row, column-2] == "A" && self[row, column-3] == "S"
      xmases << [row, column]
    end

    xmases
  end

  def vertical_xmases(row, column)
    xmases = []

    # Downwards
    if self[row+1, column] == "M" && self[row+2, column] == "A" && self[row+3, column] == "S"
      xmases << [row, column]
    end

    # Upwards
    if self[row-1, column] == "M" && self[row-2, column] == "A" && self[row-3, column] == "S"
      xmases << [row, column]
    end

    xmases
  end

  def diagonal_xmases(row, column)
    xmases = []

    # Upwards Left
    if self[row-1,column-1] == "M" && self[row-2,column-2] == "A" && self[row-3,column-3] == "S"
      xmases << [row, column]
    end

    # Upwards Right
    if self[row-1,column+1] == "M" && self[row-2,column+2] == "A" && self[row-3,column+3] == "S"
      xmases << [row, column]
    end

    # Downwards Left
    if self[row+1,column-1] == "M" && self[row+2,column-2] == "A" && self[row+3,column-3] == "S"
      xmases << [row, column]
    end

    # Downwards Right
    if self[row+1,column+1] == "M" && self[row+2,column+2] == "A" && self[row+3,column+3] == "S"
      xmases << [row, column]
    end

    xmases
  end
end

board = Board.new(input)
puts board.positions_starting_xmas.size
