def extrapolate_next(data)
  data.reverse.inject(0) {|sum, line| sum + line.last }
end

next_data = ARGF.map do |line|
  data = [line.chomp.split.map(&:to_i)]

  loop do
    new_data = data.last.each_cons(2).map { |(e1, e2)| e2 - e1 }
    break extrapolate_next(data) if new_data.all?(&:zero?)
    data.push(new_data)
  end
end

p next_data.sum
