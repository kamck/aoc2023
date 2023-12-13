def search(data)
  index = (1...data.length).find do |i|
    term = [i, data.length - i].min
    (1..term).all? { |j| data[i - j] == data[i + j - 1] }
  end 
  index || 0
end

points = ARGF.slice_after { _1.chomp.empty? }.map do |chunk|
  data = chunk.map(&:chomp).reject(&:empty?).map(&:chars)
  search(data.transpose) + search(data) * 100
end

p points.sum
