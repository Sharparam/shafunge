# encoding: utf-8
# frozen_string_literal: true

require 'io/console'
require 'matrix'

module Shafunge
  class Interpreter
    DIRECTIONS = {
      right: Vector[1, 0],
      left: Vector[-1, 0],
      up: Vector[0, -1],
      down: Vector[0, 1]
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

      case char
      when /\d/
        @stack.push char.to_i
      when '+'
        @stack.push @stack.pop + @stack.pop
      when '-'
        b, a = @stack.pop 2
        @stack.push b - a
      when '*'
        @stack.push @stack.pop * @stack.pop
      when '/'
        b, a = @stack.pop 2
        @stack.push b / a
      when '%'
        b, a = @stack.pop 2
        @stack.push b % a
      when '!'
        @stack.push @stack.pop == 0 ? 1 : 0
      when '`'
        @stack.push @stack.pop < @stack.pop ? 1 : 0
      when '>'
        @direction = :right
      when '<'
        @direction = :left
      when '^'
        @direction = :up
      when 'v'
        @direction = :down
      when '?'
        @direction = DIRECTIONS.keys.sample
      when '_'
        @direction = @stack.pop == 0 ? :right : :left
      when '|'
        @direction = @stack.pop == 0 ? :down : :up
      when '"'
        @string = !@string
      when ':'
        @stack.push @stack.last
      when '\\'
        @stack.push @stack.pop, @stack.pop
      when '$'
        @stack.pop
      when '.'
        print "#{@stack.pop} "
      when ','
        print @stack.pop.chr
      when '#'
        @skip = true
      when 'p'
        v, x, y = @stack.pop 3
        @program[x, y] = v.chr
      when 'g'
        x, y = @stack.pop 2
        @stack.push @program[x, y].ord
      when '&'
        @stack.push STDIN.getch.to_i
      when '~'
        @stack.push STDIN.getch.ord
      when '@'
        @exit = true
      end
    end

    def step
      while !@exit
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
