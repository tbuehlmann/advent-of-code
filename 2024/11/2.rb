input = File.read("input.txt").strip.split.map(&:to_i)

def cache(key)
  @cache ||= {}

  if @cache.key?(key)
    @cache[key]
  else
    @cache[key] = yield
  end
end

def blink(number, blinks)
  cache([number, blinks]) do
    if blinks == 75
      1
    else
      if number.zero?
        blink(1, blinks + 1)
      elsif (digits = number.to_s.chars).size.even?
        left = digits[0..digits.size/2 - 1].join.to_i
        right = digits[digits.size/2..-1].join.to_i

        blink(left, blinks + 1) + blink(right, blinks + 1)
      else
        blink(number*2024, blinks + 1)
      end
    end
  end
end

puts input.sum { |number| blink(number, 0) }
