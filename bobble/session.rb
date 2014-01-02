require_relative 'game.rb'
require_relative 'player.rb'

class Session
  attr_accessor :players, :num_players, :game, :abandoned
  def initialize player
    @players = [player]
    @num_players = nil
    @game = nil
    @abandoned = false
    @wordlist = load_words('words.txt')
  end

  def add_player player
    @players << player
  end

  def get_num_players conn
    @num_players = @players.first.get_num_players conn
  end

  def player_limit_reached?
    self.players.length == @num_players
  end

  def create_game board_size
    @game = Game.new board_size
  end

  def abandoned?
    return self.abandoned
  end

  def start conn
    timer = Thread.start(conn) do |conn|
      puts Time.now
      sleep self.game.duration
      puts Time.now
      winner = calculate_winner
      puts 'timing out now...'
      conn.puts 'timeout'
      if self.num_players > 1
        conn.puts "#{winner.name} wins the game with #{winner.score} points!"
      else
        conn.puts "You scored #{winner.score} points!"
      end
      conn.close
      #broadcast winner
    end
  end

  def calculate_winner
    puts 'inside calc winner'
    max_score = 0
    winner = nil
    self.players.each do |p|
      puts p.name
      if p.score > max_score
        puts p.score
        winner = p
        max_score = p.score
      end
    end
    puts winner.name
    winner
  end


  def check_word word, player

    unless self.game.is_word_valid?(word, @wordlist)
      return "#{word} is not a valid word!"
    end
    puts 'word valid'
    unless self.game.are_letters_available?(word)
      return 'Only use available letters!'
    end
    puts 'letters available'
    unless self.game.word_path_valid_on_board?(word)
      return "A word is valid only if it traces a pattern on the current board! Please try again."
    end
    puts 'word path found'
    if self.game.board.scored_words.has_key? word
      return "#{word} has already been entered! Please try again."
    else
      player.word_score = self.game.score_word(word)
      self.game.board.scored_words[word] = 1
      player.score += player.word_score if player.word_score > 0
      return "You scored #{player.word_score} points for #{word}. Your total score is #{player.score}."
    end
  end
end