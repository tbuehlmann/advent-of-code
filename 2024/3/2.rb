input = File.read("input.txt").strip

regexp = /mul\((\d{1,3}),(\d{1,3})\)/

sum = input.split("do()").sum do |part|
  enabled = part.split("don't()")[0]
  enabled.scan(regexp).sum { |a, b| a.to_i*b.to_i }
end

puts sum
