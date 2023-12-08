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

step_count = 0
curr_node = "AAA"

loop do
  step_no = step_count % map[:steps].length
  next_step = map[:steps][step_no]

  curr_node = map[curr_node].send(next_step.to_sym)
  step_count += 1

  break if curr_node == "ZZZ"
end

p step_count
