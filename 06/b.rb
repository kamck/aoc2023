(time, distance) = ARGF.map {|line| line.chomp.split(": ").last.split.inject(:+).to_i }

results = (0..time).map {|speed| speed * (time - speed) }
    .select {|e| e > distance }
    .length

p results
