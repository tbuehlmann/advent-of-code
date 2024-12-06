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

  def order!(rules)
    rule_map = rules.each_with_object(Hash.new { |hash, key| hash[key] = Set.new }) do |rule, map|
      map[rule.x] << rule.y
    end

    @pages.sort! do |a, b|
      if rule_map[a].empty?
        0
      elsif rule_map[a].include?(b)
        -1
      else
        1
      end
    end
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

incorrect_updates = updates.select { |update| !update.obeys_rules?(rules) }

sum = incorrect_updates.sum do |update|
  update.order!(rules)
  update.middle_page
end

puts sum
