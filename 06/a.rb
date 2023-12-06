records = ARGF.map {|line| line.chomp.split(": ").last.split.map(&:to_i) }

results = records.transpose.map do |time, distance|
  (0..time).map {|speed| speed * (time - speed) }
    .select {|e| e > distance }
    .length
end

p results.inject(:*)
