class Dealer < Player
  def initialize(name = 'Dealer')
    super
  end

  def take_card?
    if cards.size < 3 && (self.points < 17)
      puts 'Dealer take a card.'
      true
    else
      puts 'Dealer a skip.'
      false
    end
  end
end
