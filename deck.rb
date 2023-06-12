require_relative 'card'

class Deck
  def initialize
    @cards = []
    suits = %w[+ <3 ^ <>].freeze
    ranks = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
    ranks.each do |r|
      suits.each do |s|
        @cards << Card.new(s, r)
      end
    end
  end

  def shuffling
    @cards.shuffle!
  end

  def pull(count = 1)
    @cards.shift(count)
  end
end