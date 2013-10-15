require 'socket'
require 'json'
require_relative 'multiplayer_bobble.rb'

class Game
  @@games = []
  def initialize(letter_set, board)
    @players = []
    @@games << self
    @board = board
    @letter_set = letter_set
  end
  attr_accessor :players, :letter_set, :board

  def self.games_in_progress
    @@games
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
  #keep track of IPs and communicate to other players?
  def initialize
    puts 'new player created'
  end
end

def start_server
  #create server socket
  server = TCPServer.new('0.0.0.0', 45678)
  
  #keep track of game state in server

  loop do |c = server.accept| #create accept loop for server
    #puts 'connection accepted'
    Thread.start(c) do |conn| #create thread for each game
      #puts 'thread started'
      if !Game.is_game_in_progress? || Game.last_game_started.player_limit_exceeded?        
        conn.write true
        #puts 'true'
        board_size = conn.readpartial(64).to_i #get board size from client
        letter_set = generate_letter_set board_size*board_size #generate letter set
          
        board = Board.new(letter_set, board_size) #create board object for current game

        game = Game.new(letter_set, board) #create game and add player
        player = Player.new
        game.add_player(player)
      #puts 'board created'
        puts
      else
        game = Game.last_game_started
        #puts 'last game', game
        player = Player.new
        #puts 'created player'
        game.add_player(player)
        #puts 'added player'
        #puts game.board.board_size
        conn.write game.board.board_size
        #puts 'false'
        letter_set = game.letter_set
        #print 'letter_set', letter_set
      end
      wordlist = load_words('words.txt') #load wordlist
      #puts 'wordlist loaded'
      conn.write letter_set.to_json #pass letter set to client      

      total_score = 0
      word_score = 0
      while true #perform game computations
        #puts 'inside loop, before reading word'
        word = conn.readpartial(256).chomp
        #puts "read #{word}"
        break if word == '.'
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
          word_score = score_word(word)
          game.board.scored_words[word] = 1
          total_score += word_score if word_score
          conn.write "You scored #{word_score} points for #{word}. Your total score is #{total_score}."
        end
      end
      #puts 'while ended'
    end
  end    
end

start_server




