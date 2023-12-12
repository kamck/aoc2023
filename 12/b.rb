class String
  def replace_first(new_char) = self.gsub(/^./, new_char)

  def drop(n) = self[n, self.length]
end

def key(damaged, contigs)
  "#{damaged} #{contigs.hash}"
end

def analyze(damaged, contigs, memo)
  return memo[key(damaged, contigs)] if memo.key? key(damaged, contigs)

  if contigs.empty?
    if !damaged.include?("#") && !damaged.include?("?")
      1
    elsif !damaged.include? "#"
      1
    else
      0
    end
  elsif damaged.nil? || damaged.empty?
    0
  elsif damaged.start_with? "."
    new_damaged = damaged.drop(1)
    memo[key(new_damaged, contigs)] ||= analyze(new_damaged, contigs, memo)
  elsif damaged.start_with? "?"
    [".", "#"].inject(0) do |sum, n|
      new_damaged = damaged.replace_first(n)

      res = analyze(new_damaged, contigs, memo) 
      memo[key(new_damaged, contigs)] ||= res

      sum + res
    end
  elsif damaged.start_with? "#"
    if damaged.length < contigs.first
      0
    elsif damaged[0, contigs.first].include? "."
      0
    elsif damaged.length == contigs.first 
      contigs.length == 1 ? 1 : 0
    elsif damaged[contigs.first] == "#"
      0
    elsif damaged[contigs.first] == "?"
      new_damaged = damaged.drop(contigs.first).replace_first(".")
      new_contigs = contigs.drop(1)
      memo[key(new_damaged, new_contigs)] ||= analyze(new_damaged, new_contigs, memo)
    elsif damaged[contigs.first] == "."
      new_damaged = damaged.drop(contigs.first)
      new_contigs = contigs.drop(1)
      memo[key(new_damaged, new_contigs)] ||= analyze(new_damaged, new_contigs, memo)
    else
      binding.break
    end
  else
    binding.break
  end
end

memo = Hash.new

arrangements = ARGF.map do |line|
  damaged = ([line.chomp.split.first] * 5).join("?")
  contigs = line.chomp.split.last.split(",").map(&:to_i) * 5

  analyze(damaged, contigs, memo)
end

p arrangements.sum
