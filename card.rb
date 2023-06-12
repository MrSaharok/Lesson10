class Card
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def cost
    return 10 if picture?
    return [1, 11] if ace?

    rank.to_i
  end

  def ace?
    rank == 'A'
  end

  def picture?
    %w[J Q K].include?(rank)
  end
end