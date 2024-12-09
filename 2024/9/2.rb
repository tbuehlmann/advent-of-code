input = File.read("input.txt").strip.chars.map(&:to_i)

class FileBlock
  attr_reader :id, :size

  def initialize(id, size)
    @id = id
    @size = size
    @attempted_to_move = false
  end

  def attempted_to_move!
    @attempted_to_move = true
  end

  def attempted_to_move?
    @attempted_to_move
  end

  def print
    Kernel.print(id.to_s*size)
  end
end

class Free
  attr_accessor :size

  def initialize(size)
    @size = size
  end

  def print
    Kernel.print("."*size)
  end
end

blocks = input.flat_map.with_index do |block, index|
  if index.even?
    FileBlock.new(index/2, block)
  else
    Free.new(block)
  end
end

loop do
  file_block_index = blocks.rindex { |block| block.is_a?(FileBlock) && !block.attempted_to_move? }

  if file_block_index
    file_block = blocks[file_block_index]
    free_index = blocks.index { |block| block.is_a?(Free) && block.size >= file_block.size }

    if free_index && file_block_index > free_index
      free = blocks[free_index]

      if free.size == file_block.size
        blocks[free_index], blocks[file_block_index] = blocks[file_block_index], blocks[free_index]
      else
        # Move Free to where the FileBlock was. If there's a Free before or after that, merge.
        blocks[file_block_index] = Free.new(file_block.size)

        before = blocks[file_block_index-1]
        after = blocks[file_block_index+1]

        if before.is_a?(Free)
          blocks[file_block_index].size = blocks[file_block_index].size + before.size
          blocks[file_block_index-1] = nil
        end

        if after.is_a?(Free)
          blocks[file_block_index].size = blocks[file_block_index].size + after.size
          blocks[file_block_index+1] = nil
        end

        blocks.compact!

        # Move FileBlock to where Free was.
        blocks[free_index] = file_block

        # Move all Blocks one to the right.
        (blocks.size-1).downto(free_index+1) do |index|
          blocks[index+1] = blocks[index]
        end

        # Add the remaining Free
        blocks[free_index+1] = Free.new(free.size - file_block.size)
      end1
    end

    file_block.attempted_to_move!
  else
    break
  end
end

blocks = blocks.flat_map.with_index do |block, index|
  if block.is_a?(FileBlock)
    block.size.times.map { block.id }
  else
    block.size.times.map { "." }
  end
end

sum = 0

blocks.each_with_index do |block, index|
  if block.is_a?(Integer)
    sum += index*block
  end
end

puts sum
