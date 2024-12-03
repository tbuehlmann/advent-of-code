input = File.readlines("input.txt").map { |line| line.strip.split.map(&:to_i) }

def report_safe?(levels)
  diffs = levels.each_cons(2).map { |a, b| a - b }
  diffs.all? { |diff| diff.between?(1, 3) } || diffs.all? { |diff| diff.between?(-3, -1) }
end

puts input.count { |report| report_safe?(report) }
