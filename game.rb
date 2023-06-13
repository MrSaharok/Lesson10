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
    round
    if dealer.money <= 0 || user.money <= 0
      exit
    end
    loop do
      line
      show_cards(false)
      line
      user_select
      auto_showdown
    end
  end

  private

  def round
    [user, dealer].each(&:clear)
    @deck = Deck.new
    @deck.shuffling
    [user, dealer].each do |player|
      player.bet
      2.times { take_card(player) }
      @bank += 10
    end
  end

  def result
    if user.points == dealer.points && user.points <= 21
      dealer.money += @bank / 2
      user.money += @bank / 2
      puts 'Draw!'
    elsif (user.points > dealer.points) && user.points <= 21 || (user.points < dealer.points) && dealer.points > 21
      user.money += @bank
      puts "#{user.name}:#{user.money}$ - WIN!!!"
      puts "#{dealer.name}:#{dealer.money}$ - LOSS!!!"
    else
      dealer.money += @bank
      puts "#{dealer.name}:#{dealer.money}$ - WIN!!!"
      puts "#{user.name}:#{user.money}$ - LOSS!!!"
    end
    @bank = 0
  end

  def user_select
    puts 'Select: 1 - skip, 2 - take a card, 3 - show cards'
    user_choise = gets.chomp.to_i
    case user_choise
    when 1
      skip(user)
    when 2
      take_card(user)
    when 3
      showdown
    else
      puts 'Error input!'
      nil
    end
  end

  def skip(player)
    puts "#{player.name}  pass the turn!"
    take_card(dealer) if dealer.take_card?
  end

  def take_card(player)
    player.cards << deck.pull
  end

  def showdown
    show_cards
    line
    result
    line
    play_again
  end

  def auto_showdown
    if (user.card_limit? && dealer.card_limit?) || (user.card_limit? && !dealer.card_limit??)
      true
    else
      showdown
    end
  end

  def play_again
    puts 'Play it again? (1) Yes (2) No'
    ruling = gets.chomp.to_i
    start if ruling == 1
    exit if ruling == 2
  end

  def show_cards(flag = true)
    puts "#{user.name}: #{user.show_card}, points: #{user.points}"
    puts "#{dealer.name}: #{flag ? dealer.show_card : '* ' * dealer.cards.size}, points: #{flag ? dealer.points : ''}"
  end

  def line
    puts '=' * 21
  end
end

puts 'Please enter name: '
name = gets.chomp.to_s.capitalize

user = Player.new(name)
dealer = Dealer.new
g = Game.new(user, dealer)
g.start
