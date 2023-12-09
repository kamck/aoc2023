Pair = Data.define(:L, :R)

steps = ARGF.readline.chomp.chars
ARGF.readline                        # Throw away

map = ARGF.each_with_object({}).each_with_index do |(line, obj), index|
  node, next_steps = line.chomp.split(/\s=\s/)
  obj[node] = Pair.new(*next_steps.gsub(/\(/, "").gsub(/\)/, "").split(", "))
end

step_count = 0
curr_node = "AAA"

loop do
  next_step = steps[step_count % steps.length].to_sym

  curr_node = map[curr_node].send(next_step)
  step_count += 1

  break if curr_node == "ZZZ"
end

p step_count
