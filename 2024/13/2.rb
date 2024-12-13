input = File.read("input.txt").split("\n\n")

class ClawMachine
  def initialize(a, b, price)
    @a = a
    @b = b
    @price = price
  end

  def winning_cost
    b = (@a[0]*@price[1] - @a[1]*@price[0]) / (@b[1]*@a[0] - @a[1]*@b[0])
    a = (@price[0] - @b[0]*b)/@a[0]

    if a*@a[0] + b*@b[0] == @price[0] && a*@a[1] + b*@b[1] == @price[1]
      a*3 + b
    else
      nil
    end
  end
end

sum = input.sum do |line|
  parts = line.split("\n")

  a_x, a_y = parts[0].scan(/\d+/).map(&:to_i)
  b_x, b_y = parts[1].scan(/\d+/).map(&:to_i)
  price_x, price_y = parts[2].scan(/\d+/).map(&:to_i)

  claw_machine = ClawMachine.new([a_x, a_y], [b_x, b_y], [price_x + 10_000_000_000_000, price_y + 10_000_000_000_000])
  winning_cost = claw_machine.winning_cost

  winning_cost || 0
end

puts sum
