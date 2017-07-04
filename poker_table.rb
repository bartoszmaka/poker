require_relative 'hand'

class PokerTable
  def initialize(line)
    @line = line
    validate_table_line
    @left_hand, @right_hand = dealt_cards_divided_in_half
  end

  def strongest_hand
    if @left_hand == @right_hand
      'tie'
    elsif @left_hand > @right_hand
      'left'
    else
      'right'
    end
  end

  private

  def dealt_cards_divided_in_half
    cards_from_card_codes.each_slice(5).map do |five_cards|
      Hand.new(five_cards)
    end
  end

  def cards_from_card_codes
    @line.split(' ').map do |card_code|
      Card.new(card_code)
    end
  end

  def validate_table_line
    card_codes = @line.split(' ')
    raise PokerError::DuplicatedCardError if card_codes.length != card_codes.uniq.length
  end
end
