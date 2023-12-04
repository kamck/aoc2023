cards = ARGF.each_with_object(Array(1)) do |line, cards|
  card, numbers = line.chomp.split(":")
  current_card = card.split.last.to_i
  winning = numbers.chomp.split("|").first.split
  mine = numbers.chomp.split("|").last.split

  # In case we haven't won more cards
  cards[current_card - 1] ||= 1

  winning.intersection(mine).length.times do |k|
    cards[current_card + k] ||= 1
    cards[current_card + k] += cards[current_card - 1]
  end
end

p cards.sum
