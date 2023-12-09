Pair = Data.define(:L, :R)

steps = ARGF.readline.chomp.chars
ARGF.readline                        # Throw away

map = ARGF.each_with_object({}).each_with_index do |(line, obj), index|
  node, next_steps = line.chomp.split(/\s=\s/)
  obj[node] = Pair.new(*next_steps.gsub(/\(/, "").gsub(/\)/, "").split(", "))
end

steps = map.keys.select { _1.end_with? "A" }.collect do |curr_node|
  step_count = 0

  loop do
    next_step = steps[step_count % steps.length].to_sym

    curr_node = map[curr_node].send(next_step)
    step_count += 1

    break if curr_node.end_with? "Z"
  end

  step_count
end

p steps.inject(1) { |memo, step| memo.lcm(step) }
