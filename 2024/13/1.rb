input = File.read("input.txt").split("\n\n")

class ClawMachine
  def initialize(a, b, price)
    @a = a
    @b = b
    @price = price
    @claw = [0, 0]

    @a_pressed = 0
    @b_pressed = 0
  end

  def press_a(times)
    @claw[0] += times*@a[0]
    @claw[1] += times*@a[1]

    @a_pressed += times
  end

  def press_b(times)
    @claw[0] += times*@b[0]
    @claw[1] += times*@b[1]

    @b_pressed += times
  end

  def win?
    @claw == @price
  end

  def winning_cost
    @a_pressed*3 + @b_pressed
  end
end

sum = input.sum do |line|
  parts = line.split("\n")

  a_x, a_y = parts[0].scan(/\d+/).map(&:to_i)
  b_x, b_y = parts[1].scan(/\d+/).map(&:to_i)
  price_x, price_y = parts[2].scan(/\d+/).map(&:to_i)

  winning_cost = 0

  0.upto(100) do |a_times|
    0.upto(100) do |b_times|
      claw_machine = ClawMachine.new([a_x, a_y], [b_x, b_y], [price_x, price_y])

      claw_machine.press_a(a_times)
      claw_machine.press_b(b_times)

      if claw_machine.win?
        winning_cost = claw_machine.winning_cost
        break
      end
    end
  end

  winning_cost
end

puts sum
