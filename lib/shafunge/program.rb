# encoding: utf-8
# frozen_string_literal: true

module Shafunge
  class Program
    def initialize(file)
      @program = File.readlines(file).map { |l| l.chomp.chars }
    end

    def [](x, y)
      @program[y][x]
    end

    def []=(x, y, value)
      @program[y][x] = value
    end

    def valid?(x, y)
      return false if y < 0 || y >= @program.size
      x >= 0 && x < @program[y].size
    end
  end
end
