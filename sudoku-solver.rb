#!/usr/bin/env ruby
require 'matrix'

class Sudoku
  def initialize(lines=nil)
    if not lines
      @pussle = Matrix.build(9) {(rand*10).to_i % 9 + 1}
    else
      @pussle = Matrix.rows(lines)
    end
  end

  def output(header='The pussle: ')
    # Indicate that we are output the array
    puts header
    @pussle.to_a.each { |line| puts line.join(' ').gsub('0', '.') }
  end
end

# Setup
lines = []
invalid_line = 'Make sure that each line contains 9 characters(1-9 or .)'
invalid_count = 'Make sure that your file contains 9 lines'
invalid_file = 'File given as first argument could not be read.'

# Read file input
begin
  input = File.open(ARGV[0])
  input.each do |file_line|
    line = file_line.strip
    if line.size == 9
      lines << line.split('').map do |char|
        begin
          char.to_i
        rescue
          0
        end
      end
    else
      puts invalid_line
    end
  end
rescue
  puts invalid_file
  puts invalid_count
  puts invalid_line
end

if lines.count != 9
  puts invalid_count
  puts invalid_line
else
  o = Sudoku.new lines
  o.output
end
