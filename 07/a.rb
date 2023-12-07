HAND_ORDER = %i[
  high_card
  one_pair 
  two_pair 
  three_of_kind 
  full_house 
  four_of_kind 
  five_of_kind
].freeze

CARD_ORDER = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze

Hand = Data.define(:cards) do
  include Comparable

  def rank
    case cards.uniq.length
    when 1
      :five_of_kind
    when 2
      counts.first == 4 ? :four_of_kind : :full_house
    when 3
      counts.first == 3 ? :three_of_kind : :two_pair
    when 4
      :one_pair
    else
      :high_card
    end
  end

  def counts
    cards.uniq.map {|c| cards.count(c) }.sort.reverse
  end

  def <=>(other)
    hand_cmp = HAND_ORDER.find_index(rank) <=> HAND_ORDER.find_index(other.rank)
    hand_cmp.zero? ? compare_cards(other) : hand_cmp
  end

  def compare_cards(other)
    cards.each_with_index do |card, i|
      card_cmp = CARD_ORDER.find_index(card) <=> CARD_ORDER.find_index(other.cards[i])
      return card_cmp if !card_cmp.zero?
    end
  end
end

hands = ARGF.map do |line|
  cards, bid = line.chomp.split
  [Hand.new(cards.chars), bid.to_i]
end

p hands.sort
  .each_with_index
  .map {|(_, bid), i| bid * (i + 1) }
  .sum
