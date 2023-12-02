def get_max(str, color)
  str.scan(/(\d+) #{color.to_s}/).flatten.map(&:to_i).max
end

powers = ARGF.map do |line|
  %i[red green blue].inject(1) { |curr, i| get_max(line, i) * curr }
end

p powers.sum
