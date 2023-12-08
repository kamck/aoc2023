Pair = Data.define(:L, :R)

map = ARGF.each_with_object({}).each_with_index do |(line, obj), index|
  if index == 0
    obj[:steps] = line.chomp.chars
  elsif index == 1
  else
    node, next_steps = line.chomp.split(/\s=\s/)
    obj[node] = Pair.new(*next_steps.gsub(/\(/, "").gsub(/\)/, "").split(", "))
  end
end


steps = map.keys.select { _1.end_with? "A" }.collect do |curr_node|
  step_count = 0

  loop do
    step_no = step_count % map[:steps].length
    next_step = map[:steps][step_no]

    curr_node = map[curr_node].send(next_step.to_sym)
    step_count += 1

    break if curr_node.end_with? "Z"
  end

  step_count
end

p steps.inject(1) { |memo, step| memo.lcm(step) }
