def find_all(str, match)
  str.enum_for(:scan, match).map { Regexp.last_match.begin(0) }
end

grid = ARGF.map(&:chomp)

ratios = grid.each_with_index.flat_map do |line, line_no|
  find_all(line, /\*/).filter_map do |iden_index|
    gears = []

    (line_no-1..line_no+1).each do |y|
      next if y < 0 || y == grid.length

      find_all(grid[y], /\d+/).map do |gear_index|
        matchdata = grid[y].match(/\d+/, gear_index)
        s_begin = gear_index.zero? ? 0 : gear_index - 1
        s_end = gear_index + matchdata.to_s.length

        if iden_index.between? s_begin, s_end
          gears << matchdata.to_s
        end
      end
    end

    next unless gears.length == 2

    gears.first.to_i * gears.last.to_i
  end
end

p ratios.sum
