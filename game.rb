require_relative 'card'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'

class Game
  attr_accessor :user, :dealer, :deck, :bank

  def initialize(user, dealer)
    @user = user
    @dealer = dealer
    @bank = 0
  end

  def start
    loop do
      round
      line
      show_cards(false)
      line
      l3 = user_turn
      line
      dealer_turn unless l3
      result
      line
      exit if exit?
    end
  end

  private

  def round
    [user, dealer].each(&:clear)
    @bank = 0
    @deck = Deck.new
    @deck.shuffling
    [user, dealer].each do |player|
      player.bet
      2.times { take_card(player) }
      @bank += 10
    end
  end

  def result
    show_cards
    if user.points == dealer.points && user.points <= 21
      dealer.money += @bank / 2
      user.money += @bank / 2
      puts 'Draw!'
      puts "#{user.name}:#{user.money}$"
      puts "#{dealer.name}:#{dealer.money}$"
    elsif (user.points > dealer.points) && user.points <= 21 || (user.points < dealer.points) && dealer.points > 21
      user.money += @bank
      puts "#{user.name}:#{user.money}$ - WIN!!!"
      puts "#{dealer.name}:#{dealer.money}$ - LOSS!!!"
    else
      dealer.money += @bank
      puts "#{dealer.name}:#{dealer.money}$ - WIN!!!"
      puts "#{user.name}:#{user.money}$ - LOSS!!!"
    end
  end

  def user_turn
    puts 'Select: 1 - skip, 2 - take a card, 3 - show cards'
    user_choise = gets.chomp.to_i
    case user_choise
    when 1
      puts "#{user.name}  pass the turn!"
    when 2
      take_card(user)
      show_cards(false)
    when 3
      showdown
      true
    else
      puts 'Error input!!!!'
      raise
    end
  rescue
    retry
  end

  def take_card(player)
    player.cards << deck.pull
  end

  def showdown
    show_cards
    line
  end

  def dealer_turn
    puts "#{dealer.name} move!"
    take_card(dealer) if dealer.take_card?
  end

  def auto_showdown
    (user.card_limit? && dealer.card_limit?) || (user.card_limit? && !dealer.card_limit?)
  end

  def show_cards(flag = true)
    puts "#{user.name}: #{user.show_card}, points: #{user.points}"
    puts "#{dealer.name}: #{flag ? dealer.show_card : '* ' * dealer.cards.size}, points: #{flag ? dealer.points : ''}"
  end

  def line
    puts '=' * 21
  end

  def exit?
    not_enough_money? || user_want_to_leave?
  end

  def not_enough_money?
    dealer.money <= 0 || user.money <= 0
  end

  def user_want_to_leave?
    puts 'Play it again? (1) Yes (2) No'
    ruling = gets.chomp.to_i

    case ruling
    when 1 then return false
    when 2 then return true
    else
      puts "Error input!"
      raise
    end
  rescue
    retry
  end
end

puts 'Please enter name: '
name = gets.chomp.to_s.capitalize

user = Player.new(name)
dealer = Dealer.new
g = Game.new(user, dealer)
g.start
