#
# https://adventofcode.com/2023/day/15
#

def hash(str)
  str.chars.map(&:ord).inject(0) do |memo, char|
    (memo + char) * 17 % 256
  end
end

res = ARGF.map do |line|
  line.chomp.split(",").map {|step| hash(step) }
end

pp res.flatten.sum
