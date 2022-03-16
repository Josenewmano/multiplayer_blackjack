def move
  loop do
    ans = gets.chomp
    if ans == "hit" || ans == "h" || ans == "Hit" || ans == "HIT"
      return "hit"
    elsif ans == "stick" || ans == "s" || ans == "Stick" || ans == "STICK"
      return "stick"
    else
      sleep(1)
      puts "Type in 'hit or 'stick'. Or just use 'h' or 's' if that seems like too much work."
    end
  end
end

def score(hand)
  points = 0
  numbers = { 
  "two of hearts" => 2, "three of hearts" => 3, "four of hearts" => 4, 
  "five of hearts" => 5, "six of hearts" => 6, "seven of hearts" => 7,
  "eight of hearts" => 8, "nine of hearts" => 9, "ten of hearts" => 10,
  "jack of hearts" => 10, "queen of hearts" => 10, 
  "king of hearts" => 10, "ace of hearts" => 11,
  "two of clubs" => 2, "three of clubs" => 3, "four of clubs" => 4,
  "five of clubs" => 5, "six of clubs" => 6, "seven of clubs" => 7,
  "eight of clubs" => 8, "nine of clubs" => 9, "ten of clubs" => 10,
  "jack of clubs" => 10, "queen of clubs" => 10,
  "king of clubs" => 10, "ace of clubs" => 11,
  "two of spades" => 2, "three of spades" => 3, "four of spades" => 4, 
  "five of spades" => 5, "six of spades" => 6, "seven of spades" => 7,
  "eight of spades" => 8, "nine of spades" => 9, "ten of spades" => 10,
  "jack of spades" => 10, "queen of spades" => 10, 
  "king of spades" => 10, "ace of spades" => 11,
  "two of diamonds" => 2, "three of diamonds" => 3, "four of diamonds" => 4, 
  "five of diamonds" => 5, "six of diamonds" => 6, "seven of diamonds" => 7,
  "eight of diamonds" => 8, "nine of diamonds" => 9, "ten of diamonds" => 10,
  "jack of diamonds" => 10, "queen of diamonds" => 10, 
  "king of diamonds" => 10, "ace of diamonds" => 11
  }
  
  hand.drop(1).each do |one_card|
    points += numbers[one_card]
  end
 
  return points
end

def number?(obj)
  obj = obj.to_s unless obj.is_a? String
  /\A[+]?\d+\z/.match(obj)
end

def welcome
  message = [
    "\nWelcome to Mika's Casino BlackJack Table.", "Aces are always high.", "Five cards in your (virtual) hand trumps 21.", 
    "And six cards in your hand is better than five et cetera, et cetera.", "Feeling lucky?\n\n", "How close can you get to 21?", "Can you get to five cards?", 
    "To start, you want to get as close to 21 in as few cards as possible.", "But if you get to four cards, you might try to hold on for five.", "Weird, right?",
    "Over 16 with the best hand could squeeze out a win, but we all know what we're playing for here.\n\n", 
    "This is cards out blackjack - everybody can see every card.", "We proceed one card per player at a time.\n\n", 
    "If you want one player blackjack quit now (control + c), and try our solo Blackjack table.\n\n\n",  
    "You can use the shortcut [h] for 'hit' and the shortcut [s] for 'stick'.",
    "Control + c at any time to quit.", "Make sure you do quit when you're done, otherwise the computer will be stuck in an infinite loop.",
      "Infinite loop = tired (and warm) computer\n\n\n\n",
    ]
    message.each do |sentence|
      puts sentence
      sleep(1.5)
    end
end

def close
  sleep(5)
  puts "\n\nI guess you'll be playing again?\n\n"
  sleep(2)
  puts "Control + c to quit (if you're boring)\nAny other key to continue"
  again = gets.chomp
end

def make_players
  sleep(1)
  puts "How many players? Maximum 10. Type the number.\n\n"
  players = nil
index = 0
  
  loop do
    players  = gets.chomp
    break if number?(players) && players.to_i < 11 && players.to_i > 1
    puts "Enter a number. 2, 3, 4, 5 etc, up to 10. Get it?"
  end
  
  sleep(0.5)
  puts "\nWell done, that's a valid number of players!\n\n"
  num = players.to_i - 1

  (0..num).each do |name|
    puts "\nPlayer #{index+1} - what's your name?"
    name = gets.chomp.capitalize
    sleep(0.5)
    @in_play << Array.new(1, name)
  index += 1
  end
  puts "\n\n\n"
end

def deal
  loop do
    @in_play.each do |a|
      sleep(1.5)
      a.push(@ran_cards.pop).push(@ran_cards.pop)
      if score(a) == 22
        @busted.push(a[0])
        puts "\n#{a[0]} was dealt the #{a[1]} and the #{a[2]}. Their score so far is #{score(a)}.\n\n"
        sleep(1)
        puts "How unlucky #{a[0]} - two aces and you lose?!?! The developers are working on this issue."
        sleep(2)
        puts "But you still lose, #{a[0]}. Sorry about that."
      else
        puts "\n#{a[0]} was dealt the #{a[1]} and the #{a[2]}. Their score so far is #{score(a)}.\n\n"
      end
    end
    puts "\n\n"
    if @busted.size > 0
      sleep(3)
      puts "That wasn't actually really fair on #{@busted.join(" and ")} was it? We'll have to deal again. Sorry to tease you all!"
      @busted.clear
      @in_play.each do |a|
        a.pop
        a.pop
      end
    else
      break
    end
  end
end

def turns
  sleep(2)
  puts "\n\n\n"
  @i = 0
  
  while @in_play.size > 0 do
    loop do
      break if @in_play.size == 0
      if score(@in_play[@i]) > 19
        puts "#{@in_play[@i][0]}, your score is #{score(@in_play[@i])} so any card will make you bust. You'll have to stop there.\n\n"
        add_final(@in_play[@i])
        index_looper
      else
        break
      end
    end

    if @in_play.size == 1
      puts "#{@in_play[@i][0]} is the last player in the game. #{score(@in_play[@i])} so far, from #{@in_play[@i].size - 1} cards. Hit or stick?"
    elsif @in_play.size > 1
      puts "It's #{@in_play[@i][0]}'s turn. #{score(@in_play[@i])} so far, from #{@in_play[@i].size - 1} cards. Hit or stick?"
    else 
      break
    end

    case 
    when move == "hit"
      sleep(1.5)
      @in_play[@i].push(@ran_cards.pop)
      puts "\n#{@in_play[@i][0]} got the #{@in_play[@i][-1]}."
      if score(@in_play[@i]) > 21
        puts "Whoops, #{@in_play[@i][0]} busted with #{score(@in_play[@i])}.\n\n"
        @busted.push(@in_play[@i][0])
        @in_play.delete_at(@i)
        @i -= 1
      elsif score(@in_play[@i]) == 21
        puts "That's 21, #{@in_play[@i][0]} may well have won. Let's wait and see.\n\n"
        add_final(@in_play[@i])
      elsif score(@in_play[@i]) == 20
        puts "That's 20, #{@in_play[@i][0]}. You have to stick now as another card will make you bust.\n\n"
        add_final(@in_play[@i])
      else
        puts "#{@in_play[@i][0]}'s score so far is #{score(@in_play[@i])}\n\n"
      end
    else
      if @in_play[@i].size > 5
        puts "#{@in_play[@i][0]} has a #{@in_play[@i].size - 1} card trick. Looking pretty good for the win.\n\n"
        add_final(@in_play[@i])
      elsif score(@in_play[@i]) < 16
        puts "#{score(@in_play[@i])} isn't enough #{@in_play[@i][0]}, you can't win. You can have another chance to be brave on your next go."
      else
        puts "#{@in_play[@i][0]}'s final score is #{score(@in_play[@i])} from #{@in_play[@i].size - 1} cards. We'll see if that's enough in a moment.\n\n"
        add_final(@in_play[@i])
      end
    end
    index_looper
  end
  @places_index = @final.size
end

def add_final(player)
  @final.push(player)
  @in_play.delete(player)
  @i -= 1
end

def index_looper
  @i += 1
  if @i > (@in_play.size - 1)
    @i -= @i
  end
end

def final_scores_to_places_hash
  while @final.size > 0 do
    @final.each do |fin|
      if fin.size == 9
        @places['8 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif fin.size == 8
        @places['7 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif fin.size == 7
        @places['6 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif fin.size == 6
        @places['5 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 21 && fin.size == 3
        @places['21, 2 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 21 && fin.size == 4
        @places['21, 3 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 21 && fin.size == 5
        @places['21, 4 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 20 && fin.size == 3
        @places['20, 2 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 20 && fin.size == 4
        @places['20, 3 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 20 && fin.size == 5
        @places['20, 4 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 19 && fin.size == 3
        @places['19, 2 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 19 && fin.size == 4
        @places['19, 3 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 19 && fin.size == 5
        @places['19, 4 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 18 && fin.size == 3
        @places['18, 2 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 18 && fin.size == 4
        @places['18, 3 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 18 && fin.size == 5
        @places['18, 4 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 17 && fin.size == 3
        @places['17, 2 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 17 && fin.size == 4
        @places['17, 3 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 17 && fin.size == 5
        @places['17, 4 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 16 && fin.size == 3
        @places['16, 2 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 16 && fin.size == 4
        @places['16, 3 cards'].push(fin[0])
        @final.delete(fin)
        next
      elsif score(fin) == 16 && fin.size == 5
        @places['16, 4 cards'].push(fin[0])
        @final.delete(fin)
      end
    end
  end
end

class Integer
  def ordinal
    if self == 1
      "1st"
    elsif self == 2
      "2nd"
    elsif self == 3
      '3rd'
    else
      "#{self}th"
    end
  end
end

def positions_message
  puts "Tension builds as we add the scores.....\n\n\n"
  sleep(6)
  puts "That took surprisingly long for a computer to do didn't it?\n\n"
  sleep(1)
  puts "Spoiler alert, it didn't actually take that long...\n\n"
  sleep(1)
  
  if @busted.size > 0
    puts "Let's get the awkward bit out of the way first..."
    sleep(2)
    case
    when @busted.size > 2
      puts @busted.join(" and ") + " are all losers!"
    when @busted.size == 2
      puts @busted.join(" and ") + " are our two losers!"
    when @busted.size == 1
      puts "#{@busted[0]} was our loser!"
    end
    puts "But enough about them...."
  end
  
  sleep(5)
  puts "\n\n\n"

  @places.each_value do |array|
    if array.size > 0
      @places_index -= (array.size - 1)
      if @places_index == 1
        puts "Some might say that everybody that we've heard about so far is a loser. Not us though..."
        sleep(3)
        puts "And the moment that we've all been waiting for.."
        sleep(3)
        print "Victory goes to......     "
        sleep(3)
        array.each do |str|
          str.upcase!
        end
        puts array.join(" and ") + "  !!!!!"
      else
        sleep(2)
        puts "In #{@places_index.ordinal} place, " + array.join(" and ") + "."
      end
      @places_index -= 1
      puts "\n\n"
    end
  end 
end

def final_scores
  final_scores_to_places_hash
  positions_message
end

def run_game
  @in_play = []
  @final = []
  @busted = []
  @cards = [
    "two of hearts", "three of hearts", "four of hearts", 
    "five of hearts", "six of hearts", "seven of hearts",
    "eight of hearts", "nine of hearts", "ten of hearts",
    "jack of hearts", "queen of hearts", 
    "king of hearts", "ace of hearts",
    "two of clubs", "three of clubs", "four of clubs",
    "five of clubs", "six of clubs", "seven of clubs",
    "eight of clubs", "nine of clubs", "ten of clubs",
    "jack of clubs", "queen of clubs",
    "king of clubs", "ace of clubs",
    "two of spades", "three of spades", "four of spades", 
    "five of spades", "six of spades", "seven of spades",
    "eight of spades", "nine of spades", "ten of spades",
    "jack of spades", "queen of spades", 
    "king of spades", "ace of spades",
    "two of diamonds", "three of diamonds", "four of diamonds", 
    "five of diamonds", "six of diamonds", "seven of diamonds",
    "eight of diamonds", "nine of diamonds", "ten of diamonds",
    "jack of diamonds", "queen of diamonds", 
    "king of diamonds", "ace of diamonds"
  ]
  @ran_cards = @cards.shuffle
  @places = {
    '16, 4 cards' => [], '16, 3 cards' => [], '16, 2 cards' => [], 
    '17, 4 cards' => [], '17, 3 cards' => [], '17, 2 cards' => [], 
    '18, 4 cards' => [], '18, 3 cards' => [], '18, 2 cards' => [],
    '19, 4 cards' => [], '19, 3 cards' => [], '19, 2 cards' => [],
    '20, 4 cards' => [], '20, 3 cards' => [], '20, 2 cards' => [],
    '21, 4 cards' => [], '21, 3 cards' => [], '21, 2 cards' => [], 
    '5 cards' => [], '6 cards' => [], '7 cards' => [], '8 cards' => [], 
  }

  welcome
  make_players
  deal
  turns
  final_scores
  close
end

loop do
  run_game
end