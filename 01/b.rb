DIGITS = %w[one two three four five six seven eight nine]

Index = Data.define(:index, :value) do
  include Comparable

  def <=>(other)
    index <=> other.index
  end
end

def find_all_occurrences(str, search)
  str.enum_for(:scan, search).map { Regexp.last_match.begin(0) }
end

def find_indexes(line)
  all_indexes = DIGITS.each_with_index.flat_map do |digit, index|
    find_all_occurrences(line, digit).map { Index.new(_1, index + 1) }
  end

  line.chars.each_with_index do |char, i|
    all_indexes << Index.new(i, char.to_i) if char =~ /[[:digit:]]/
  end

  all_indexes
end

d = ARGF.each_line.map do |line|
  indexes = find_indexes(line.chomp)
  "#{indexes.min.value}#{indexes.max.value}".to_i
end
p d.sum
