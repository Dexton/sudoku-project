#!/usr/bin/env ruby
require './sudoku'

# Setup
lines = []
invalid_line = 'Make sure that each line contains 9 characters(1-9 or .)'
invalid_count = 'Make sure that your file contains 9 lines'
invalid_file = 'File given as first argument could not be read.'

def process(line)
  # Change the line into a integer array
    if line.size == 9
      line.split('').map do |char|
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

# Read file input
begin
  input = File.open(ARGV[0])
  input.each do |file_line|
    line = file_line.strip
    lines << process(line)
  end
rescue => e
  puts e
end

if lines.count != 9
  puts invalid_count
  puts invalid_line
else
  o = Sudoku.new lines
  o.output
  puts o.solved?
  if not o.valid?
    puts 'The imported sudoku game is not valid'
  end
  puts o.gaps.count
  puts o.difficulty
  o.solve
  o.output
  puts 'Done!'
end
