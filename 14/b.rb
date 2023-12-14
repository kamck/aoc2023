# https://adventofcode.com/2023/day/14#part2

ROUND = "O"
CUBE  = "#"
EMPTY = "."

LIMIT = 1_000_000_000

grid = ARGF.map(&:chomp).map(&:chars)

def north(data)
  grid = data.map(&:dup)
  grid.each_with_index do |line, y|
    next if y == 0

    line.each_with_index do |cell, x|
      next unless grid[y][x] == ROUND

      (0...y).reverse_each do |j|
        break if grid[j][x] != EMPTY

        grid[j][x] = ROUND
        grid[j+1][x] = EMPTY
      end
    end
  end
  grid
end

def south(data)
  north(data.reverse).reverse
end

def west(grid)
  north(grid.transpose).transpose
end

def east(grid)
  west(grid.map(&:reverse)).map(&:reverse)
end

def cycle(data)
  grid = north(data)
  grid = west(grid)
  grid = south(grid)
  east(grid)
end

iter = 0
history = []

loop do
  grid = cycle(grid)
  iter += 1
  index = history.find_index(grid)

  unless index.nil?
    cycle = history[index, history.length]
    grid = cycle[(LIMIT - iter) % cycle.length]
    break
  end

  history << grid
  break if iter >= LIMIT
end
  
score = grid.each_with_index.map do |line, index|
  line.count { _1 == ROUND } * (grid.length - index)
end

p score.sum
