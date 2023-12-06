def process_map(map, chunk)
  map.keys.each do |seed_no|
    found = chunk.find do |line| 
      if line =~ /^\d/
        dest, src, range = line.chomp.split.map(&:to_i)
        map[seed_no].last.to_i.between? src, src + range - 1
      end
    end

    map[seed_no] << if found
      dest, src, range = found.chomp.split.map(&:to_i)
      diff = map[seed_no].last - src
      dest + diff
    else
      map[seed_no].last
    end
  end
end

def init_map(map, line)
  line.split(":").last.split.each { map[_1] = [_1.to_i] }
end

seed_map = ARGF.slice_when { _1.chomp.empty? }.each_with_object(Hash.new) do |chunk, map|
  if chunk.first =~ /^seeds/
    init_map(map, chunk.first.chomp)
  else
    process_map(map, chunk)
  end
end

p seed_map.values.min_by { |s| s.last }.last
