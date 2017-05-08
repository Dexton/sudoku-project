require 'matrix'
require './cell'
require 'set'

class Sudoku
  attr_accessor :pussle, :size, :part_size, :solver
  def initialize(lines=nil, solver=:backtracker)
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
    @solver = self.method(solver)
    @size = @pussle.column_count
    @characters = (1..@size).to_a
    @part_size = Math.sqrt(@size).to_i
  end

  def one_rule(sets)
    # Apply the only rule of the game, no repeated characters in the sets
    sets.collect { |set| set.count == set.uniq.count }.all?
  end

  def valid?
    @pussle.each_with_index { |el, row, col| return false if not adheres_to_rule? row, col }
    true
  end

  def solved?
    @pussle.collect { |cell| cell.solved? } .all?
  end

  def adheres_to_rule?(row_num, col_num)
    sets = gather_sets_for(row_num, col_num)
    # We can repeate gaps but not characters
    sets.map { |set| set.delete(0) }
    one_rule(sets)
  end

  def gather_sets_for(row_num,col_num=row_num)
    sets = [row(row_num), col(col_num), part(row_num)]
    sets.collect {|set| set.collect(&:solved).to_a.flatten.compact}
  end

  def solve
    solver.call
  end

  def bad_solver
    # Insert random values for testing
    @pussle.each { |cell| cell.set (1..@size).to_a.sample if not cell.solved? }
  end

  def backtracker(row_num=0, col_num=0)
    if row_num == 0 and col_num == 0
      row_num, col_num = next_position(row_num, col_num)
    end

    if row_num  == @size
      return true
    end

    @characters.each do |el|
      @pussle[row_num, col_num].set el
      if adheres_to_rule?(row_num, col_num)
        next_row, next_col= next_position(row_num, col_num)
        if backtracker(next_row, next_col)
          return true
        end
      end
    end
    @pussle[row_num, col_num].clear
    return false
  end

  def next_position(row_num, col_num)
    while row_num != @size  and @pussle[row_num, col_num].solved?
      col_num += 1
      if col_num == @size
        col_num = 0
        row_num += 1
      end
    end
    return row_num, col_num
  end

  def possible(row_num, col)
    # Find the characters that are not in the matched row, column or part
    used_up = gather_sets_for(row_num,col).flatten.uniq!
    possible = @characters.clone
    used_up.each { |el| possible.delete el }
    possible
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
