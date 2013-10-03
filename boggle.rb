#Implements Boggle!

# TIPS
# Possible way to check for word board path --> precompute all possible words in board and just lookup every time
# Graph search - avoid cycles
require File.expand_path('word_game_for_boggle.rb')

class Letter
	def initialize(letter, row, column)
		@letter = letter
		@row = row
		@column = column
	end
	attr_accessor :letter, :row, :column
end

def make_boggle_board(letter_set, board_size)
	graph = {}
	for i in 0...letter_set.length
		letter_obj = Letter.new(letter_set[i], i/board_size, i%board_size)
		graph[letter_obj] = []
		for neighbor in graph.keys
			if (neighbor.column == letter_obj.column-1 && neighbor.row == letter_obj.row) || (neighbor.column == letter_obj.column-1 && neighbor.row == letter_obj.row-1) || (neighbor.column == letter_obj.column && neighbor.row == letter_obj.row-1) || (neighbor.column == letter_obj.column+1 && neighbor.row == letter_obj.row+1)

				graph[neighbor] << letter_obj
				graph[letter_obj] << neighbor
			end
		end
	end
	graph
end

def display_board(letter_set, board_size)
	for i in 0...board_size*board_size
		if (i+1)%board_size == 0
			puts letter_set[i]
			puts
		else
			print letter_set[i],' '
		end
	end
end

def word_path_valid_on_board?(word, board)
	true
end

def play_boggle
	wordlist = load_words('words.txt')
	word_score = total_score = 0
	puts
	print 'Enter size of Boggle board required: '
	board_size = gets.chomp.to_i
	letter_set = generate_letter_set(board_size*board_size)
	board = make_boggle_board(letter_set, board_size)
	while true
		display_board(letter_set, board_size)
		print 'Enter a valid word: '
		word = gets.chomp
		puts
		break if word == '.'
		unless is_word_valid?(word, wordlist)
			puts "#{word} is not a valid word!"
			next
		end
		unless are_letters_available?(letter_set, word)
			puts 'Only use available letters!'
			next
		end
		unless word_path_valid_on_board?(word, board)
			puts "A word is valid only if it traces a pattern on the current board! Please try again."
			next
		end
		#TODO - Check if word path exists on board
		word_score = score_word(word)
		total_score += word_score if word_score
		puts "You scored #{word_score} points for #{word}."
		puts "Your total score is #{total_score}."
		puts
	end
	puts 'Thank you for playing Boggle. Goodbye!'
end

