Grid = Data.define(:grid) do
  include Enumerable

  def above(line_no, index, length)
    if line_no > 0
      left_index = index.zero? ? 0 : index - 1
      new_len = index.zero? ? length + 1 : length + 2
      grid[line_no - 1][left_index, new_len]
    end
  end

  def below(line_no, index, length)
    if line_no < grid.length - 1
      left_index = index.zero? ? 0 : index - 1
      new_len = index.zero? ? length + 1 : length + 2
      grid[line_no + 1][left_index, new_len]
    end
  end

  def left(line_no, index)
    if index > 0
      grid[line_no][index - 1]
    end
  end

  def right(line_no, index, length)
    if index < grid[line_no].length - 1
      grid[line_no][index + length]
    end
  end

  def each(&block)
    grid.each(&block)
  end
end


def get_all(str, match)
  str.enum_for(:scan, match).map { Regexp.last_match.begin(0) }
end

def is_part?(grid, line_no, index, length)
  %i[above below left right].any? do |sym|
    found = grid.send(sym, line_no, index, length)&.gsub(/\d|\./, "") || ""
    !found.empty?
  end
end

grid = Grid.new(ARGF.readlines.map(&:chomp))

part_nos = grid.each_with_index.map do |line, line_no|
  get_all(line, /\d+/).map do |i|
    found = line.match(/\d+/, i)

    if is_part? grid, line_no, i, found.to_s.length
      found.to_s.to_i
    end
  end
end

p part_nos
  .flatten
  .reject(&:nil?)
  .sum
