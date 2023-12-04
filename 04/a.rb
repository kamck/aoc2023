points = ARGF.map do |line|
  _, numbers = line.chomp.split(":")
  winning = numbers.chomp.split("|").first.split
  mine = numbers.chomp.split("|").last.split

  count = winning.intersection(mine).length
  if count.zero?
    0
  else
    (count - 1).times.inject(1) { |curr, i| curr * 2 }
  end
end

p points.sum
