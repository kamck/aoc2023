class String
  def replace_first(new_char) = self.gsub(/^./, new_char)

  def drop(n) = self[n, self.length]
end

def analyze(damaged, contigs)
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
    analyze(damaged.drop(1), contigs)
  elsif damaged.start_with? "?"
    [".", "#"].inject(0) do |sum, n|
      sum + analyze(damaged.replace_first(n), contigs) 
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
      analyze(new_damaged, contigs.drop(1))
    elsif damaged[contigs.first] == "."
      new_damaged = damaged.drop(contigs.first)
      analyze(new_damaged, contigs.drop(1))
    else
      binding.break
    end
  else
    binding.break
  end
end

arrangements = ARGF.map do |line|
  damaged = line.chomp.split.first
  contigs = line.chomp.split.last.split(",").map(&:to_i)

  analyze(damaged, contigs)
end

p arrangements.sum
