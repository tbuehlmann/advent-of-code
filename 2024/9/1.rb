input = File.read("input.txt").strip.chars.map(&:to_i)

blocks = input.flat_map.with_index do |block, index|
  if index.even?
    id = index/2
    block.times.map { id }
  else
    block.times.map { "." }
  end
end

loop do
  first_free_index = blocks.index(".")
  last_file_block_index = blocks.rindex { |block| block.is_a?(Integer) }

  if first_free_index < last_file_block_index
    blocks[first_free_index], blocks[last_file_block_index] = blocks[last_file_block_index], blocks[first_free_index]
  else
    break
  end
end

sum = 0

blocks.each_with_index do |block, index|
  if block.is_a?(Integer)
    sum += index*block
  end
end

puts sum
