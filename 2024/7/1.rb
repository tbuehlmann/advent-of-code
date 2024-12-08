input = File.readlines("input.txt").map(&:strip)

# For 4 operands we need 3 operators. This Enum turns 000 into +++, 001 into ++*, 010 into +*+ and so on.
class OperatorEnum
  OP_MAP = {"0" => :+, "1" => :*}

  include Enumerable

  def initialize(size:, configuration:)
    @permutation = configuration.to_s(OP_MAP.size).rjust(size, "0")
  end

  def each
    if block_given?
      @permutation.each_char do |char|
        yield OP_MAP[char]
      end
    else
      to_enum(:each)
    end
  end
end

def equation_truthy?(result, operands)
  configurations = 2**(operands.size-1)

  configurations.times do |configuration|
    enum = OperatorEnum.new(size: operands.size-1, configuration:).each

    if result == operands.inject { |a, b| a.public_send(enum.next, b) }
      return true
    end
  end

  false
end

sum = input.sum do |line|
  result, operands = line.split(":")
  result = result.to_i
  operands = operands.split.map(&:to_i)

  if equation_truthy?(result, operands)
    result
  else
    0
  end
end

puts sum
