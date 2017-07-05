require_relative 'combination'
require_relative 'card'

class Hand
  include Comparable

  attr_accessor :cards, :combination

  def initialize(cards)
    @cards = cards
    validate_cards_count
    @combination = Combination.new(@cards)
  end

  def <=>(other)
    [combination.score,
     combination.first_combination_card,
     combination.second_combination_card,
     sorted_cards_scores] <=>
      [other.combination.score,
       other.combination.first_combination_card,
       other.combination.second_combination_card,
       other.sorted_cards_scores]
  end

  def sorted_cards_scores
    cards.map(&:score).sort.reverse
  end

  private

  def validate_cards_count
    raise PokerError::InvalidNumberOfCardsError if cards.count != 5
  end
end
