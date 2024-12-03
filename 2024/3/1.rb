input = File.read("input.txt")

regexp = /mul\((\d{1,3}),(\d{1,3})\)/
puts input.scan(regexp).sum { |a, b| a.to_i*b.to_i }
