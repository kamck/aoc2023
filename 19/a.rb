#
# https://adventofcode.com/2023/day/19
#
ACCEPTED = "A"
REJECTED = "R"

Workflow = Data.define(:name, :rules)

def parse_workflows(chunk)
  chunk.map.each_with_object({}) do |line, hsh|
    i_start = line.index("{")
    i_end = line.index("}")

    name = line[0, i_start]
    rules = line.chomp[i_start + 1, i_end - i_start - 1]#.split(",")

    hsh[name] = rules
  end
end

def parse_ratings(chunk)
  chunk.filter_map do |line|
    next if line.chomp.empty?
    eval(line.chomp.gsub(/=/, ":"))
  end
end

def input
  ARGF.slice_before { _1.chomp.empty? }.each_with_index.map do |chunk, i|
    if i == 0
      parse_workflows(chunk)
    else
      parse_ratings(chunk)
    end
  end
end

def result(rating, instr)
  x, m, a, s = rating.values_at(:x, :m, :a, :s)
  instr_res = eval(instr.split(":", 2).first)
  res_true, res_false = instr.split(":", 2).last.split(",", 2)
  instr_res ? res_true : res_false
end

def accepted?(rating, workflows, instr)
  res = result(rating, instr)

  case
  when res == ACCEPTED then true
  when res == REJECTED then false
  when workflows.key?(res) then accepted?(rating, workflows, workflows[res])
  else accepted?(rating, workflows, res)
  end
end

workflows, ratings = input
selected = ratings.filter { |rating| accepted? rating, workflows, workflows["in"] }
pp selected.flat_map(&:values).sum
