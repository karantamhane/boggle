#Implements Boggle!

# TIPS
# Possible way to check for word board path --> precompute all possible words in board and just lookup every time
# graph search - avoid cycles
require File.expand_path('word_game_for_boggle.rb')

# class Letter
# 	def initialize(letter, row, column)
# 		@letter = letter
# 		@row = row
# 		@column = column
# 		@up = nil
# 		@down = nil
# 		@left = nil
# 		@right = nil
# 		@lup = nil
# 		@rup = nil
# 		@ldown = nil
# 		@rdown = nil
# 		@visited = false
# 	end
# 	attr_accessor :letter, :row, :column, :up, :down, :left, :right, :lup, :rup, :ldown, :rdown, :visited
# end

# def make_boggle_board(letter_set, board_size)
# 	board = {}
# 	for i in 0...letter_set.length
# 		letter_obj = Letter.new(letter_set[i], i/board_size, i%board_size)
# 		board[letter_obj] = 1
# 		for neighbor in board.keys
# 			if (neighbor.column == letter_obj.column-1 && neighbor.row == letter_obj.row)
# 				letter_obj.left = [neighbor.letter, neighbor]
# 				neighbor.right = [letter_obj.letter, letter_obj]
# 			elsif (neighbor.column == letter_obj.column-1 && neighbor.row == letter_obj.row-1)
# 				letter_obj.lup = [neighbor.letter, neighbor]
# 				neighbor.rdown = [letter_obj.letter, letter_obj]
# 			elsif (neighbor.column == letter_obj.column && neighbor.row == letter_obj.row-1)
# 				letter_obj.up = [neighbor.letter, neighbor]
# 				neighbor.down = [letter_obj.letter, letter_obj]
# 			elsif (neighbor.column == letter_obj.column+1 && neighbor.row == letter_obj.row-1)
# 				letter_obj.rup = [neighbor.letter, neighbor]
# 				neighbor.ldown = [letter_obj.letter, letter_obj]
# 			end
# 		end
# 	end
# 	board
# end

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

# def word_path_valid_on_board?(word, board)
# 	#Try recursion to take into account duplicate letters (second, third, fourth letters can also have adjacent duplicates! not just first letters.)
# 	#TODO - keep track of already formed words
# 	first_letter_list = []
# 	board.keys.each do |letter_obj|
# 		if letter_obj.letter == word[0]
# 			first_letter_list << letter_obj
# 		end
# 	end
# 	first_letter_list_index = 0
# 	board_size = Math.sqrt(board.keys.length)
# 	while first_letter_list_index < first_letter_list.length
# 		letter_found = true
# 		word_found = false
# 		word_letter_index = 1
# 		first_letter = first_letter_list[first_letter_list_index]
# 		first_letter.visited = true
# 		while word_letter_index < word.length
# 			#puts first_letter.letter
# 			if first_letter.up && first_letter.up[0] == word[word_letter_index] && first_letter.up[1].visited == false
# 				first_letter = first_letter.up[1]
# 			elsif first_letter.down && first_letter.down[0] == word[word_letter_index] && first_letter.down[1].visited == false
# 				first_letter = first_letter.down[1]
# 			elsif first_letter.left && first_letter.left[0] == word[word_letter_index] && first_letter.left[1].visited == false
# 				first_letter = first_letter.left[1]
# 			elsif first_letter.right && first_letter.right[0] == word[word_letter_index] && first_letter.right[1].visited == false
# 				first_letter = first_letter.right[1]
# 			elsif first_letter.lup && first_letter.lup[0] == word[word_letter_index] && first_letter.lup[1].visited == false
# 				first_letter = first_letter.lup[1]
# 			elsif first_letter.rup && first_letter.rup[0] == word[word_letter_index] && first_letter.rup[1].visited == false
# 				first_letter = first_letter.rup[1]
# 			elsif first_letter.ldown && first_letter.ldown[0] == word[word_letter_index] && first_letter.ldown[1].visited == false
# 				first_letter = first_letter.ldown[1]
# 			elsif first_letter.rdown && first_letter.rdown[0] == word[word_letter_index] && first_letter.rdown[1].visited == false
# 				first_letter = first_letter.rdown[1]
# 			else
# 				letter_found = false
# 				#puts 'letter not found!'
# 				break
# 			end
# 			first_letter.visited = true
# 			word_letter_index += 1
# 		end
# 		if letter_found
# 			word_found = true
# 		end
# 		first_letter_list_index += 1
# 		#Reset visited nodes to not visited
# 		for letter_obj in board.keys
# 			letter_obj.visited = false
# 		end
# 	end
# 	word_found
# end


# def display_objects_on_board(board)
# 	start = nil
# 	count = 0
# 	row = 0
# 	while count < board.length
# 		for obj in board.keys
# 			if obj.row == row && obj.column == 0
# 				start = obj
# 				break
# 			end
# 		end
# 		for i in 0...Math.sqrt(board.length)
# 			count += 1
# 			print start.letter,' '
# 			start = start.right[1] if start.right
# 		end
# 		puts
# 		row += 1
# 	end
# end

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


def word_path_valid_on_board?(word, board)
	first_letter_list = []
	for letter_obj in board.keys
		if letter_obj.letter == word[0]
			first_letter_list << letter_obj
		end
	end
	first_letter_list.each do |first_letter|
		if search(board, first_letter, word, 1)
			board.keys.each do |letter_obj|
				letter_obj.visited = false
			end
			return true
		else
			board.keys.each do |letter_obj|
				letter_obj.visited = false
			end
			next
		end
	end
	false
end


def search(board, letter_obj, word, word_letter_index)
	if word_letter_index == word.length
		return true
	end
	letter_obj.visited = true
	board[letter_obj].each do |neighbor|
		#puts 'inside neighbors of', letter_obj.letter, 'neighbor', neighbor.letter
		if neighbor.visited == false && neighbor.letter == word[word_letter_index]
			#puts 'found', neighbor.letter, word_letter_index+1
			if search(board, neighbor, word, word_letter_index+1)
				return true
			else
				board.keys.each do |letter_obj|
					letter_obj.visited = false
				end
				next
			end
		else
			next
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
	puts
	until board_size.kind_of?(Integer) && board_size > 0 && board_size < 10
		puts 'Please enter an integer between 1 and 10!'
		board_size = gets.chomp.to_i
	end
	letter_set = generate_letter_set(board_size*board_size) #['d','r','o','g','o','d','t','u','l']
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
		word_score = score_word(word)
		total_score += word_score if word_score
		puts "You scored #{word_score} points for #{word}."
		puts "Your total score is #{total_score}."
		puts
	end
	puts 'Thank you for playing Boggle. Goodbye!'
end
