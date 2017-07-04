require 'pry'
require_relative 'card'

class Combination
  attr_reader :name

  ROYALS = %w[A K Q J T].freeze
  COMBINATION_NAMES = %i[high_hand one_pair two_pairs three_of_a_kind straight flush
                         full_house four_of_a_kind straight_flush royal_flush].freeze

  def initialize(cards)
    @cards = cards
    @hash_with_cards_amounts = parse_cards_to_hash_with_amounts(cards)
    iterate_through_each_combination_from_the_strongest_one
  end

  def score
    COMBINATION_NAMES.index(@name)
  end

  def first_combination_card
    first_pair = hash_with_repeated_elements_only.sort_by { |_k, v| v }[1]
    first_pair.nil? ? 0 : first_pair[0]
  end

  def second_combination_card
    second_pair = hash_with_repeated_elements_only.sort_by { |_k, v| v }[2]
    second_pair.nil? ? 0 : second_pair[0]
  end

  private

  def hash_with_repeated_elements_only
    @hash_with_cards_amounts.select { |_k, v| v > 1 }
  end

  def iterate_through_each_combination_from_the_strongest_one
    COMBINATION_NAMES.reverse.each do |combination_name|
      @name = combination_name
      method_name = combination_name.to_s + '?'
      break if send(method_name) == true
    end
  end

  def parse_cards_to_hash_with_amounts(cards)
    cards.each_with_object(Hash.new(0)) { |card, hash| hash[card.rank] += 1 }
  end

  def royal_flush?
    @cards.map(&:rank).sort == ROYALS.sort && flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def straight?
    @cards.map(&:score).sort.each_cons(2).map { |x, y| y - x } == [1, 1, 1, 1]
  end

  def flush?
    @cards.map(&:suit).uniq.length == 1
  end

  def four_of_a_kind?
    @hash_with_cards_amounts.values.max == 4
  end

  def full_house?
    @hash_with_cards_amounts.values.sort.max(2) == [3, 2]
  end

  def three_of_a_kind?
    @hash_with_cards_amounts.values.max == 3
  end

  def two_pairs?
    @hash_with_cards_amounts.values.max(2) == [2, 2]
  end

  def one_pair?
    @hash_with_cards_amounts.values.max == 2
  end

  def high_hand?
    @hash_with_cards_amounts.values.max == 1
  end
end
