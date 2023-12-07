HAND_ORDER = %i[
  high_card
  one_pair 
  two_pair 
  three_of_kind 
  full_house 
  four_of_kind 
  five_of_kind
].freeze

CARD_ORDER = %w[J 2 3 4 5 6 7 8 9 T Q K A].freeze

JOKER = "J"

Hand = Data.define(:cards) do
  include Comparable

  def rank
    case with_wildcards.uniq.length
    when 1
      :five_of_kind
    when 2
      counts.first.last == 4 ? :four_of_kind : :full_house
    when 3
      counts.first.last == 3 ? :three_of_kind : :two_pair
    when 4
      :one_pair
    else
      :high_card
    end
  end

  def counts
    with_wildcards.tally.sort_by {|_, v| v }.reverse
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

  def with_wildcards
    if cards.include? JOKER
      if cards.all? {|card| card == JOKER }
        %w[A A A A A]
      else
        cards.map { |card| card == JOKER ? card_to_replace : card }
      end
    else
      cards
    end
  end

  def card_to_replace
    most_frequent = cards.reject { _1 == JOKER}
      .tally
      .sort_by {|_, v| v }
      .reverse

    if most_frequent.length > 1 && most_frequent.first.last == most_frequent[1].last
      most_frequent[0, 2].sort_by { CARD_ORDER.find_index(_1) }.last.first
    else
      most_frequent.first.first
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
