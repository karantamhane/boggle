#Implements Boggle!


require File.expand_path('word_game_for_boggle.rb')

class Letter
	def initialize(letter, row, column)
		@letter = letter
		@row = row
		@column = column
		@visited = false
	end
	attr_accessor :letter, :row, :column, :visited
end

def make_boggle_board(letter_set, board_size)
	board = {}
	for i in 0...letter_set.length
		letter_obj = Letter.new(letter_set[i], i/board_size, i%board_size)
		board[letter_obj] = []
		for neighbor in board.keys
			if (neighbor.column == letter_obj.column-1 && neighbor.row == letter_obj.row) || (neighbor.column == letter_obj.column-1 && neighbor.row == letter_obj.row-1) || (neighbor.column == letter_obj.column && neighbor.row == letter_obj.row-1) || (neighbor.column == letter_obj.column+1 && neighbor.row == letter_obj.row-1)
				
				board[letter_obj] << neighbor
				board[neighbor] << letter_obj
			end
		end
	end
	board
end

def display_board(letter_set, board_size)
	puts 'Available letters: '
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
	#TODO - keep track of already formed words
	first_letter_list = []
	board.keys.each do |letter_obj|
		if letter_obj.letter == word[0]
			first_letter_list << letter_obj
		end
	end
	first_letter_list.each do |first_letter|
		first_letter.visited = true
		if search(board, first_letter, word, 1)
			board.keys.each do |obj|
				obj.visited = false
			end
			return true
		else
			board.keys.each do |obj|
				obj.visited = false
			end
			next
		end
	end
	false
end

def search(board, letter_obj, word, word_letter_index)
	return true if word_letter_index == word.length
	board[letter_obj].each do |neighbor|
		if neighbor.visited == false && neighbor.letter == word[word_letter_index]
			if search(board, neighbor, word, word_letter_index+1)
				board.keys.each do |obj|
					obj.visited = false
				end
				return true
			else
				board.keys.each do |obj|
					obj.visited = false
				end
				next
			end
		end
	end
	false
end

def play_boggle
	puts 'Welcome to Boggle! Press . anytime to exit'
	puts
	wordlist = load_words('words.txt')
	word_score = total_score = 0
	puts
	#Assert presence of number for board
	print 'To create an N X N Boggle board, enter N: '
	board_size = gets.chomp.to_i
	until board_size.kind_of?(Integer) && board_size > 0 && board_size < 10
		print 'Please enter an integer between 1 and 10! '
		board_size = gets.chomp.to_i
		puts
	end
	letter_set = generate_letter_set(board_size*board_size) #['t','n','w', 'p','e','r','g','e','g']
	board = make_boggle_board(letter_set, board_size)
	scored_words = {}
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
		if scored_words.has_key? word
			puts "#{word} has already been entered! Please try again."
			next
		else
			word_score = score_word(word)
			scored_words[word] = 1
			total_score += word_score if word_score
			puts "You scored #{word_score} points for #{word}."
			puts "Your total score is #{total_score}."
			puts
		end
	end
	puts 'Thank you for playing Boggle. Goodbye!'
end
