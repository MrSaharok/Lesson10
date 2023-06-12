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
    loop do
      line
      show_card(false)
      line
      user_select
      auto_finish
    end
  end

  def round
    @deck = Deck.new
    @deck.shuffling
    [user, dealer].each do |player|
      player.bet
      2.times { take_card(player) }
      @bank += 10
    end
  end

  def distribution_money
    case result
    when 1
      dealer.money += @bank / 2
      user.money += @bank / 2
    when 2
      user.money += @bank
    when 3
      dealer.money += @bank
    end
    @bank = 0
    puts "#{dealer.name}:#{dealer.money}"
    puts "#{user.name}:#{user.money}"
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
      open_cards
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

  def open_cards
    show_card
    line
    distribution_money
    line
    new_round
    continue?
  end

  def auto_finish
    if (user.card_count && dealer.card_count) || (user.card_count && !dealer.card_count)
      true
    else
      open_cards
    end
  end

  def new_round
    [user, dealer].each(&:clear)
  end

  def result
    if user.points == dealer.points && user.points <= 21
      puts 'Draw!'
      1
    elsif (user.points > dealer.points) && user.points <= 21 || (user.points < dealer.points) && dealer.points > 21
      puts "#{user.name} WIN!!!"
      2
    else
      puts "#{dealer.name} WIN!!!"
      3
    end
  end

  def continue?
    puts 'Play it again? 1.Yes 2. No'
    ruling = gets.chomp.to_i
    start if ruling == 1
    exit if ruling == 2
  end

  def show_card(flag = true)
    puts "#{user.name}: #{user.show_cards}, points: #{user.points}"
    puts "#{dealer.name}: #{flag ? dealer.show_cards : '* ' * dealer.cards.size}, points: #{flag ? dealer.points : ''}"
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