require_relative 'card'
require_relative 'deck'

class Player
  attr_accessor :money
  attr_reader :name, :cards

  def initialize(name)
    @name = name
    @money = 100
    @cards = []
  end

  def bet
    @money -= 10
  end

  def card_limit?
    cards.size < 3
  end

  def points(points = 0)
    cards.flatten.each do |card|
      points += if card.ace? && points >= 10
                  card.cost.first
                elsif card.ace?
                  card.cost.last
                else
                  card.cost
                end
    end
    points
  end

  def show_card
    cards.flatten.map { |card| "#{card.rank}#{card.suit}" }
  end

  def clear
    cards.clear
  end
end
