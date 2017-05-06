require 'matrix'
require './cell'
require 'set'

class Sudoku
  attr_accessor :pussle, :size, :part_size
  def initialize(lines=nil)
    if not lines
      @pussle = Matrix.build(9) {(rand*10).to_i % 9 + 1}
    else
      @pussle = Matrix.build(lines.count) do |row,col|
        element = lines[row][col]
        if element == 0
          Cell.new
        else
          Cell.new(1, element)
        end
      end
    end
    @size = @pussle.column_count
    @characters = (1..@size).to_a
    @part_size = Math.sqrt(@size).to_i
  end

  def one_rule(sets)
    # Apply the only rule of the game
    sets.collect { |set| set.count == set.uniq.count }.all?
  end

  def self.is_gap?(char)
    not char == 0
  end

  def valid?
    (0...@size).collect { |i| adheres_to_rule?(i) }.all?
  end

  def adheres_to_rule?(i)
    sets = gather_sets_for(i)
    # We can repeate gaps but not characters
    sets.map { |set| set.delete(0) }
    one_rule(sets)
  end

  def gather_sets_for(row_num,col_num=row_num)
    sets = [row(row_num), col(col_num), part(row_num)]
    sets.collect {|set| set.collect(&:solved).to_a.compact}
  end

  def solve
    @pussle.each_with_index do |cell, row_num, col_num|
        if cell.is_gap?
          fill(row_num,col_num)
        end
    end
  end

  def fill(row, col)
    # Find the characters that are not in the matched row, column or part
    used_up = gather_sets_for(row,col).flatten.uniq!
    possible = @characters.clone
    possible.map { |el| possible.delete el }
    puts 'Used up ' + used_up.to_s
    puts 'Filling row ' + row.to_s + ' col ' + col.to_s + ' with ' + possible.to_s
    @pussle[row, col].fill(possible.compact)
  end

  def gaps
    @pussle.select { |cell| cell.is_gap?}
  end

  def all_there?(arr)
    @characters.to_set == arr.to_set
  end

  def row(n)
    @pussle.row(n)
  end

  def col(n)
    @pussle.column(n)
  end

  def part(n)
    s = @part_size
    x = (n/s)*s
    y = (n%s)*s
    @pussle.minor(x,@part_size, y, @part_size)
  end

  def difficulty
    case gaps.count
    when 0
      'This is solved'
    when (1..50)
      'Easy'
    when (51..55)
      'Medium'
    when (56..57)
      'Hard'
    else
      'Samurai' if gaps.count > 57
    end
  end

  def output(header='The pussle: ')
    # Indicate that we are output the array
    puts header
    @pussle.to_a.each do  |row|
      line = row.collect &:value
      puts line.join(' ')
    end
  end
end
