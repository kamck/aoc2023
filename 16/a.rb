#
# https://adventofcode.com/2023/day/16
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

def score(history, grid)
  history.filter { _1.x.between?(0, grid.first.length - 1) && _1.y.between?(0, grid.length - 1) }
    .map { _1.to_h.except(:direction) }
    .uniq
    .count
end

grid = ARGF.readlines(chomp: true)
markers = [Marker.new(Vector.new(0, 0, :right))]
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

p score(history, grid)
