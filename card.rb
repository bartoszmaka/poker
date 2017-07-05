require_relative 'poker_error'

class Card
  include Comparable

  attr_reader :name, :rank, :suit

  VALID_SUITS = %w[S H D C].freeze
  VALID_RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze

  def initialize(name)
    @name = name
    @rank = name.chars.first
    @suit = name.chars.last
    validate_card_name
  end

  def <=>(other)
    score <=> other.score
  end

  def score
    VALID_RANKS.index(rank)
  end

  private

  def validate_card_name
    return if VALID_SUITS.include?(suit) && VALID_RANKS.include?(rank)
    raise PokerError::InvalidCardError
  end
end
