Lookup = Data.define(:range, :dest)

def get_seeds(line)
  line.split(": ")
    .last
    .split
    .map(&:to_i)
    .each_slice(2)
    .map {|(start, len)| (start...start+len) }
    .sort_by(&:first)
end

def parse_map(chunk)
  chunk.shift
  chunk.pop if chunk.last.chomp.empty?

  chunk.map do |line|
    src, dest, len = line.chomp.split.map(&:to_i)
    range = (src...src+len)
    Lookup.new(range, dest)
  end.sort_by { _1.range.first }
end

def load_data
  ARGF.slice_when { _1.chomp.empty? }.each_with_object([]) do |chunk, map|
    if chunk.first.start_with? "seeds"
      map << get_seeds(chunk.first.chomp)
    else
      map << parse_map(chunk)
    end
  end
end

def find_covered_range(val, ranges)
  covered = ranges.find {|e| e.range.cover? val }
  if covered
    offset = val - covered.range.begin
    covered.dest + offset
  else
    val
  end
end

def follow_map(val, map)
  if map.length == 1
    return map.first.find {|e| e.cover? val }
  else
    new_val = find_covered_range(val, map.first)
    follow_map(new_val, map.slice(1, map.length))
  end
end

seed_map = load_data.reverse
location = 0

loop do
  break if follow_map(location, seed_map)
  location += 1
end

p location
