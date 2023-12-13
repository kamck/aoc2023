def old_search(data)
  index = (1...data.length).find do |i|
    term = [i, data.length - i].min
    (1..term).all? { |j| data[i - j] == data[i + j - 1] }
  end 
  index || 0
end

def new_search(data, orig)
  index = (1...data.length).find do |i|
    next if i == orig

    smudge_found = false
    term = [i, data.length - i].min

    (1..term).all? do |j|
      if data[i - j] == data[i + j - 1] 
        true
      else
        if smudge_found
          false
        else
          diff_count = data[i - j].each_with_index.count do |char, n|
            char == data[i + j - 1][n]
          end
          
          if diff_count == data[i - j].length - 1
            smudge_found = true
            true
          end
        end
      end
    end
  end 
  index || 0
end

def search(data)
  orig = old_search(data)
  new_search(data, orig)
end

points = ARGF.slice_after { _1.chomp.empty? }.map do |chunk|
  data = chunk.map(&:chomp).reject(&:empty?).map(&:chars)
  search(data.transpose) + search(data) * 100
end

p points.sum
