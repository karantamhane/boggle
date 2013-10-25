require 'socket'
require 'json'
require_relative 'multiplayer_bobble.rb'
require_relative 'bobble_server.rb'

class Game
  @@games = []
  attr_accessor :players, :letter_set, :board, :game_active, :max_score, :duration, :winner
  def initialize(letter_set, board)
    @game_active = true
    @players = []
    @@games << self
    @board = board
    @letter_set = letter_set
    @max_score = 0
    @duration = 120
    @winner = nil
  end

  def self.last_game_started
    @@games.last
  end

  def player_limit_exceeded?
    @players.length == 2
  end

  def self.is_game_in_progress?
    !@@games.empty?  
  end

  def add_player(player)
    @players << player
  end
end

class Player
  attr_accessor :name, :score, :word_score, :thread, :active
  #keep track of IPs and communicate to other players?
  def initialize(name, connection, thread)
    @name = name
    @word_score = 0
    @score = 0
    @connection = connection
    @thread = thread
    @active = true
  end
end

def select_server
  select_server = TCPServer.new('0.0.0.0', 45677)
  puts 'select server up'
  loop do |conn = select_server.accept|
    select = conn.readpartial(64).chomp
    conn.close
    if select == 'no'
      puts 'single server up'
      Thread.start { start_server_single }
    else
      Thread.start { start_server_multi }
    end
  end
end


def start_server_multi
  #create server socket
  
  server = TCPServer.new('0.0.0.0', 45678)
  #puts 'multi server up'
  #ask for single player or multiplayer

  #Have your own protocols for message chunks (newline delimited)

  loop do #create accept loop for server
    c = server.accept
    thread = Thread.start(c) do |conn| #create thread for each game
      name = conn.readpartial(64).chomp #get player name
      player = Player.new(name, conn, Thread.current)
      #player.pry
      #puts "Thread for #{player.name}"
      
      #TODO - In multiplayer game, wait till all players join before displaying board
      if !Game.is_game_in_progress? || !Game.last_game_started.game_active || Game.last_game_started.player_limit_exceeded?        
        conn.write true #send check for game_in_progress?
        board_size = conn.readpartial(64).to_i #get board size from client
        letter_set = generate_letter_set board_size*board_size #generate letter set
        board = Board.new(letter_set, board_size) #create board object for current game
        game = Game.new(letter_set, board) #create game and add player
        game.add_player(player)
        puts
      else
        game = Game.last_game_started
        puts game.board.board_size
        game.add_player(player) 
        conn.write game.board.board_size
        letter_set = game.letter_set
        #print 'letter_set', letter_set
      end

      wordlist = load_words('words.txt') #load wordlist
      conn.write letter_set.to_json #pass letter set to client


      while true #perform game computations
        #puts "Game active? = #{game.game_active}"
        #puts 'inside loop, before reading word'
        word = conn.readpartial(256).chomp
        puts word
        #puts "read #{word}"
        break if word == '.' || !game.game_active
        #puts 'word received', word
        unless is_word_valid?(word, wordlist)
          conn.write "#{word} is not a valid word!"
          next
        end
        #puts 'word valid'

        unless are_letters_available?(letter_set, word)
          conn.write 'Only use available letters!'
          next
        end
        #puts 'letters available'

        unless word_path_valid_on_board?(word, game.board)
          conn.write "A word is valid only if it traces a pattern on the current board! Please try again."
          next
        end
        #puts 'word path found'

        #puts game.board.scored_words
        if game.board.scored_words.has_key? word
          conn.write "#{word} has already been entered! Please try again."
          next
        else
          player.word_score = score_word(word)
          #puts player.word_score
          game.board.scored_words[word] = 1
          player.score += player.word_score if player.word_score
          conn.write "You scored #{player.word_score} points for #{word}. Your total score is #{player.score}."
        end
      end

      game.players.each do |p|
        if p.score > game.max_score
          game.winner = p
          game.max_score = p.score
        end
      end

      #puts 'while loop ended'
      game.game_active = false if game.game_active && word == '.'
      #puts "game_active = #{game.game_active}"
      #set all players inactive thru a method
      #use read and write
      player.active = false if !game.game_active
      #puts "player.active = #{player.active}"

      #puts "game active #{game.game_active}"
      #puts "player active #{player.active}"

      game.players.each do |plyr|
        if plyr.active
          #puts "#{player.name}'s thread => #{player.thread}"
          plyr.thread.join
        end
      end

      #puts "We went through #{player.name} and are ready to end"

      # conn.write "The game has ended"
      if !player.active
        game.players.delete(player)
        Game.games.delete(game) if game.players == []
        conn.close
      end
      #break #Breaks you out of thread loop & kills it

      conn.write "#{winner.name} wins with a score of #{winner.score} points!" if winner
      conn.close
    end
    #thread ends
  end
  #server loop ends

end
#start_server ends

#start_server
select_server



