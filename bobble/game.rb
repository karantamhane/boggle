
require_relative 'bobble_utils.rb'

class Letter
  def initialize letter
    @letter = letter
    @visited = false
  end
  attr_accessor :letter, :visited
end

class Board
  attr_accessor :letter_set, :scored_words, :graph, :board_size
  def initialize board_size
    @letter_set = self.generate_letter_set(board_size*board_size)
    @board_size = board_size
    @graph = {}
    @scored_words = {}
    @letter_obj_list = []
    #making a list of Letter objects from letter_set
    for index in 0...letter_set.length
      letter_obj = Letter.new(letter_set[index])
      @graph[letter_obj] = []
      @letter_obj_list << letter_obj
    end
    #building the graph (hash of Letter object => list of neighbors)
    for index in 0...@letter_obj_list.length
      letter_obj = @letter_obj_list[index]
      row = index/@board_size
      column = index % @board_size
      #looking at each object's neighbors and adding them to graph[letter_obj]
      for i in [-1,0,1]
        for j in [-1,0,1]
          unless (i == 0 && j == 0) || row+i < 0 || row+i >= board_size || column+j < 0 || column+j >= board_size
            @graph[letter_obj] << @letter_obj_list[@board_size*(row+i) + column+j]
          end
        end
      end
    end
  end

  def generate_initial_alphabet_set
    letter_frequency = {'a'=>9, 'j'=>1, 's'=>4, 'b'=>2, 'k'=>1, 't'=>6, 'c'=>2, 'l'=>4, 'u'=>4, 'd'=>4, 'm'=>2, 'v'=>2, 
          'e'=>12, 'n'=>6, 'w'=>2, 'f'=>2, 'o'=>8, 'x'=>1, 'g'=>3, 'p'=>2, 'y'=>2, 'h'=>2, 'q'=>1, 'z'=>1, 'i'=>9, 'r'=>6}
    final_cons = []
    final_vows = []
    cons = 'bcdfghjklmnpqrstvwxyz'.split('')
    cons.each do |letter|
      for i in 0...letter_frequency[letter]
        final_cons << letter
      end
    end
    vows = 'aeiou'.split('')
    vows.each do |letter|
      for i in 0...letter_frequency[letter]
        final_vows << letter
      end
    end
    final_cons.shuffle!
    final_vows.shuffle!
    return final_cons, final_vows
  end

  def generate_letter_set num_letters
    consonants, vowels = self.generate_initial_alphabet_set
    letter_set = []
    num_vowels = num_letters/3
    for i in 0...num_vowels
      letter_set << vowels.sample
    end
    for j in 0...(num_letters-num_vowels)
      letter_set << consonants.sample
    end
    letter_set.shuffle!
  end

  def display
    puts 'Available letters: '
    for i in 0...@board_size*@board_size
      if (i+1)% @board_size == 0
        puts @letter_set[i]
        puts
      else
        print @letter_set[i],' '
      end
    end
  end
end

class Game
  attr_accessor :board, :duration
  def initialize(board_size)
    @board = Board.new(board_size)
    @duration = 20*(board_size - 1)
  end

  def is_word_valid?(word, wordlist)
    wordlist.include? word
  end

  def are_letters_available?(word)
    word.split('').each do |letter|
      return false unless word.count(letter) <= @board.letter_set.count(letter)
    end
    true
  end

  def word_path_valid_on_board? word
    #TODO - keep track of already formed words
    first_letter_list = []
    @board.graph.keys.each do |letter_obj|
      if letter_obj.letter == word[0]
        first_letter_list << letter_obj
      end
    end
    first_letter_list.each do |first_letter|
      first_letter.visited = true
      if search(first_letter, word, 1)
        @board.graph.keys.each do |obj|
          obj.visited = false
        end
        return true
      else
        @board.graph.keys.each do |obj|
          obj.visited = false
        end
        next
      end
    end
    false
  end

  def search(letter_obj, word, word_letter_index)
    return true if word_letter_index == word.length
    @board.graph[letter_obj].each do |neighbor|
      if neighbor.visited == false && neighbor.letter == word[word_letter_index]
        if search(neighbor, word, word_letter_index+1)
          @board.graph.keys.each do |obj|
            obj.visited = false
          end
          return true
        else
          @board.graph.keys.each do |obj|
            obj.visited = false
          end
          next
        end
        next
      end
    end
    false
  end

  def score_word word
    score = 0
    word.split('').each do |letter|
      score += LETTER_SCORE[letter]
    end
    if word.length <= 3
      score
    elsif word.length <=6
      score*2
    elsif word.length > 6
      score*3
    end
  end
end















