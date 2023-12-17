#
# https://adventofcode.com/2023/day/16#part2
#
require "set"

LIMIT = 10

DIRMAP = {
  "." => {
    right: :right,
    left: :left,
    down: :down,
    up: :up,
  },
  "/" => {
    right: :up,
    left: :down,
    down: :left,
    up: :right,
  },
  "\\" => {
    right: :down,
    left: :up,
    down: :right,
    up: :left,
  },
  "|" => {
    down: :down,
    up: :up,
  },
  "-" => {
    right: :right,
    left: :left,
  },
}

Vector = Data.define(:x, :y, :direction)

class Marker
  attr_reader :current
  attr_accessor :active

  def initialize(vector)
    @current = vector
    @active = true
  end

  def right
    @current = Vector.new(@current.x + 1, @current.y, :right)
  end

  def down
    @current = Vector.new(@current.x, @current.y + 1, :down)
  end

  def left
    @current = Vector.new(@current.x - 1, @current.y, :left)
  end

  def up
    @current = Vector.new(@current.x, @current.y - 1, :up)
  end

  def valid?(grid)
    @active && @current.x.between?(0, grid.first.length-1) &&
      @current.y.between?(0, grid.length-1)
  end

  def deep_dup
    Marshal.load(Marshal.dump(self))
  end
end

def get_starts(grid)
  x_limit = grid.first.length - 1
  y_limit = grid.length - 1

  [
    (0..x_limit).map { |x| Vector.new(x, 0, :down) },
    (0..y_limit).map { |y| Vector.new(x_limit, y, :left) },
    (0..x_limit).map { |x| Vector.new(x, y_limit, :up) },
    (0..y_limit).map { |y| Vector.new(0, y, :right) },
  ].flatten
end

def score(history, grid)
  history.filter { _1.x.between?(0, grid.first.length - 1) && _1.y.between?(0, grid.length - 1) }
    .map { _1.to_h.except(:direction) }
    .uniq
    .count
end

grid = ARGF.readlines(chomp: true)

scores = get_starts(grid).map do |start|
  markers = [Marker.new(start)]
  history = Set.new

  loop do
    markers.each do |marker|
      next unless marker.valid? grid

      unless history.add?(marker.current)
        marker.active = false
      end

      cell = grid[marker.current.y][marker.current.x]

      if cell == "|" && %i[left right].include?(marker.current.direction)
        new_marker = marker.deep_dup
        markers << new_marker
        marker.up
        new_marker.down
      elsif cell == "-" && %i[up down].include?(marker.current.direction)
        new_marker = marker.deep_dup
        markers << new_marker
        marker.left
        new_marker.right
      else
        marker.send(DIRMAP[cell][marker.current.direction])
      end
    end

    break unless markers.any? { _1.valid?(grid) }
  end

  score(history, grid)
end

p scores.max
