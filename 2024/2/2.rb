input = File.readlines("input.txt").map { |line| line.strip.split.map(&:to_i) }

def report_tolerant_safe?(levels)
  report_safe?(levels) || any_sub_report_safe?(levels)
end

def any_sub_report_safe?(levels)
  0.upto(levels.size - 1).any? do |index|
    levels_dupe = levels.dup
    levels_dupe.delete_at(index)

    report_safe?(levels_dupe)
  end
end

def report_safe?(levels)
  diffs = levels.each_cons(2).map { |a, b| a - b }
  diffs.all? { |diff| diff.between?(1, 3) } || diffs.all? { |diff| diff.between?(-3, -1) }
end

puts input.count { |report| report_tolerant_safe?(report) }
