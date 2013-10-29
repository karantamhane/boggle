
require_relative 'session.rb'
require_relative 'bobble_utils.rb'

#####################################################################
#Use gets and puts on connection to communicate with client
#####################################################################

class Player
  attr_accessor :name, :score, :thread, :session, :word_score
  def initialize
    @name = nil
    @score = 0
    @word_score = 0
    @thread = nil
    @session = nil
  end

  def get_name conn
    conn.puts 'Welcome to Bobble! Press \'.\' during a game to exit.'
    conn.puts 'Enter your name: '
    @name = conn.gets.chomp
  end

  def get_num_players conn
    conn.puts 'How many players do you want in the game? '
    @num_players = conn.gets.chomp.to_i
    puts "num_players = #{@num_players}"
    @num_players
  end

  def get_board_size conn
    puts 'asking for board_size'
    conn.puts 'To create an N X N Boggle board, enter N (3 <= N <= 10): '
    conn.gets.chomp.to_i
  end

  def display_board conn, letter_set
    board_size = self.session.game.board.board_size
    for i in 0...board_size*board_size
      conn.puts letter_set[i]
    end
  end 


  def start_thread connection
    self.thread = Thread.start(connection) do |conn|
      self.get_name conn
      #multiplayer = conn.gets.chomp
      # if multiplayer == 'no'
      #   self.session.create_game self.get_board_size conn
      # else
      #  puts 'multiplayer'
      if self == self.session.players.first
        puts 'sending new session msg'
        conn.puts 'new_session'
        num_players = self.session.get_num_players conn if self.session.num_players != 1
        self.session.create_game self.get_board_size conn
        #self.session.game.board.display
      else
        conn.puts 'nope'
      end

      until self.session.player_limit_reached?
        sleep 2
      end
      conn.puts true #signalling client that player limit reached
      #end
      puts 'Starting game...'
      puts conn.puts self.session.game.board.board_size
      self.session.start conn
      while true
        display_board conn, self.session.game.board.letter_set
        word = conn.gets.chomp
        puts 'server got word', word
        break if word == '.'
        puts 'past the break statement'
        conn.puts self.session.check_word word, self
      end
      if word == '.'
        conn.puts 'quitter'
      end
    end
  end
end



