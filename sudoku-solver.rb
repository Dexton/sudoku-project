#!/usr/bin/env ruby
require 'getoptlong'
require './sudoku'

# Setup
lines = []
solver = :backtracker
show_difficulty = false
file = ''
invalid_line = 'Make sure that each line contains 9 characters(1-9 or .)'
invalid_count = 'Make sure that your file contains 9 lines'
invalid_file = 'File given as first argument could not be read.'
invalid_input = 'Failed to parse input please refere to README.md'

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
      raise invalid_line
    end
end

def handle_arguments(opt, arg)
end

# Read file input
begin
  opts = GetoptLong.new(
    ['--file', '-f', GetoptLong::REQUIRED_ARGUMENT],
    ['--difficulty', '-d', GetoptLong::OPTIONAL_ARGUMENT],
    ['--solver', '-s', GetoptLong::OPTIONAL_ARGUMENT]
  )

  opts.each do |opt, arg|
    case opt
    when '--file'
      file = arg.strip
      puts file
    when '--difficulty'
      show_difficulty = arg.strip == 'yes'
    when '--solver'
      solver = arg.strip.to_sym
    end
  end

  input = File.open(file)
  input.each do |file_line|
    line = file_line.strip
    lines << process(line)
  end
rescue => e
  raise e
end

if lines.count != 9
  raise invalid_count
else
  o = Sudoku.new lines, solver
  o.output 'Input pussle: '
  if not o.valid?
    raise 'The imported sudoku game is not valid'
  end
  if show_difficulty
    puts o.difficulty
  end
  o.solve
  o.output
  puts 'Done!'
end
