# https://adventofcode.com/2023/day/14

ROUND = "O"
CUBE  = "#"
EMPTY = "."

grid = ARGF.map(&:chomp).map(&:chars)

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

score = grid.each_with_index.map do |line, index|
  line.count { _1 == ROUND } * (grid.length - index)
end

p score.sum
