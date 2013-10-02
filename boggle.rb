#Implements Boggle!

# take in 'n' to decide size of board
# generate set of nxn letters (word_game)
# write class to wrap letters in objects
# use graph to represent board of objects
# display board
# take in word
# verify if letters present in board (word_game)
# verify if path exists in board (here)
# verify if word is valid (word_game)
# score word (word_game)
# store scored words to avoid rescoring

# TIPS
# Possible way to check for word board path --> precompute all possible words in board and just lookup every time
# Graph search - avoid cycles

#TODO - change play_game to cancel all print msgs
#TODO - change word_game's play_game method so it doesn't delete used letters
require File.expand_path('word_game_for_boggle.rb')

print 'Enter size of Boggle board required: '
board_size = gets.chomp
puts

class Letter
	@@row = 0
	@@column = 0
	def initialize(letter)
		@letter = letter
		@neighbors = []
		if @@column == board_size
			@@row += 1
			@@column = 0
		else
			@@column += 1
		end
		@row = @@row
		@column = @@column
	end
	attr_accessor :letter, :neighbors, :row, :column
end

class LetterGraph
	def initialize(letter_set)
		@letter_set = letter_set
		@letter_obj_set = []
	end
#Generate graph of Letters
	def make_letter_obj_list
		@letter_set.each do |letter|
			letter_obj = Letter.new
			letter_obj.letter = letter
			@letter_obj_set << letter_obj
		end
	end

end

def display_board
end

def create_boggle_board(board_size)
	letter_set = generate_letter_set(board_size*board_size)
	letter_graph = LetterGraph(letter_set).new
end


