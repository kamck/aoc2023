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

def find_numeric_words(line)
  DIGITS.each_with_index.flat_map do |digit, index|
    find_all_occurrences(line, digit).map { Index.new(_1, index + 1) }
  end
end

def find_digits(line)
  line.chars
    .each_with_index
    .select { |char, _| char =~ /[[:digit:]]/ }
    .map { |char, i| Index.new(i, char.to_i) }
end

d = ARGF.map do |line|
  indexes = find_numeric_words(line) + find_digits(line)
  "#{indexes.min.value}#{indexes.max.value}".to_i
end

p d.sum
