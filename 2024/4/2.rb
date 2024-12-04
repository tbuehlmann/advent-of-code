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

  def x_mas_positions
    positions = []

    @rows_count.times do |row|
      @columns_count.times do |column|
        if x_mas?(row, column)
          positions << [row, column]
        end
      end
    end

    positions
  end

  private

  def x_mas?(row, column)
    if self[row, column] == "A"
      top_left_to_bottom_right_neighbors = self[row-1, column-1].to_s + self[row+1, column+1].to_s
      bottom_left_to_top_right_neighbors = self[row+1, column-1].to_s + self[row-1, column+1].to_s

      ["MS", "SM"].include?(top_left_to_bottom_right_neighbors) && ["MS", "SM"].include?(bottom_left_to_top_right_neighbors)
    end
  end
end

board = Board.new(input)
puts board.x_mas_positions.size
