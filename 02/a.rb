MAX = { red: 12, green: 13, blue: 14 }

def valid?(str, color)
  str.scan(/(\d+) #{color.to_s}/).flatten.map(&:to_i).max <= MAX[color]
end

games = ARGF.map do |line|
  game, sets = line.chomp.split(": ")

  if %i[red green blue].all? { |color| valid?(sets, color) }
    game.split.last.to_i
  end
end

p games.reject(&:nil?).sum
