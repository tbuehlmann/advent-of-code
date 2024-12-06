input = File.read("input.txt").strip.split

class Rule
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Update
  def initialize(pages)
    @pages = pages
  end

  def obeys_rules?(rules)
    rules.all? do |rule|
      if @pages.include?(rule.x) && @pages.include?(rule.y)
        x_index = @pages.index(rule.x)
        y_index = @pages.index(rule.y)

        x_index < y_index
      else
        true
      end
    end
  end

  def middle_page
    middle_position = (@pages.size/2.0).ceil
    @pages[middle_position - 1]
  end
end

rules = []
updates = []

input.each do |line|
  if line.include?("|")
    x, y = line.split("|").map(&:to_i)
    rules << Rule.new(x, y)
  elsif line.include?(",")
    pages = line.split(",").map(&:to_i)
    updates << Update.new(pages)
  end
end

correct_updates = updates.select do |update|
  update.obeys_rules?(rules)
end

puts correct_updates.sum(&:middle_page)
