d = ARGF.map do |line|
  first = line.chars.find { _1 =~ /[[:digit:]]/ }
  last = line.chars.reverse.find { _1 =~ /[[:digit:]]/ }
  (first + last).to_i
end
puts d.sum
