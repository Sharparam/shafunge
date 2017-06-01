# encoding: utf-8
# frozen_string_literal: true

require 'io/console'
require 'matrix'

module Shafunge
  # Executes Befunge code from a loaded program.
  class Interpreter
    DIRECTIONS = {
      right: Vector[1, 0],
      left: Vector[-1, 0],
      up: Vector[0, -1],
      down: Vector[0, 1]
    }.freeze

    OPERATIONS = {
      /\d/ => ->(char) { @stack.push char.to_i },
      '+' => -> { @stack.push @stack.pop + @stack.pop },
      '-' => lambda do
        b, a = @stack.pop 2
        @stack.push b - a
      end,
      '*' => -> { @stack.push @stack.pop * @stack.pop },
      '/' => lambda do
        b, a = @stack.pop 2
        @stack.push b / a
      end,
      '%' => lambda do
        b, a = @stack.pop 2
        @stack.push b % a
      end,
      '!' => -> { @stack.push @stack.pop.zero? ? 1 : 0 },
      '`' => -> { @stack.push @stack.pop < @stack.pop ? 1 : 0 },
      '>' => -> { @direction = :right },
      '<' => -> { @direction = :left },
      '^' => -> { @direction = :up },
      'v' => -> { @direction = :down },
      '?' => -> { @direction = DIRECTIONS.keys.sample },
      '_' => -> { @direction = @stack.pop.zero? ? :right : :left },
      '|' => -> { @direction = @stack.pop.zero? ? :down : :up },
      '"' => -> { @string = !@string },
      ':' => -> { @stack.push @stack.last },
      '\\' => -> { @stack.push @stack.pop, @stack.pop },
      '$' => -> { @stack.pop },
      '.' => -> { print "#{@stack.pop} " },
      ',' => -> { print @stack.pop.chr },
      '#' => -> { @skip = true },
      'p' => lambda do
        v, x, y = @stack.pop 3
        @program[x, y] = v.chr
      end,
      'g' => lambda do
        x, y = @stack.pop 2
        @stack.push @program[x, y].ord
      end,
      '&' => -> { @stack.push STDIN.getch.to_i },
      '~' => -> { @stack.push STDIN.getch.ord },
      '@' => -> { @exit = true }
    }.freeze

    def initialize(program)
      @program = program
      @stack = []
      @direction = :right
      @string = false
      @skip = false
      @pos = Vector[0, 0]
    end

    def process(char)
      if @string && char != '"'
        @stack.push char.ord
        return
      end

      op = OPERATIONS.find { |k, _| k === char }
      instance_exec char, &op.last if op
    end

    def step
      until @exit
        if @skip
          @skip = false
        else
          begin
            process @program[*@pos]
          rescue NoMethodError
            abort "\nInvalid program position: #{@pos}"
          end
        end

        @pos += DIRECTIONS[@direction]
      end
    end
  end
end
