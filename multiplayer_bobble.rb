#Implements Boggle!


require File.expand_path('word_game_for_boggle.rb')

class Letter
	def initialize(letter)
		@letter = letter
		#@row = row
		#@column = column
		@visited = false
	end
	attr_accessor :letter, :row, :column, :visited
end

#Try making a board class
def make_boggle_board(letter_set, board_size)
	board = {}
	for i in 0...letter_set.length
		letter_obj = Letter.new(letter_set[i])
		letter_obj.row = i/board_size
		letter_obj.column = i%board_size
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
	board.graph.keys.each do |letter_obj|
		if letter_obj.letter == word[0]
			first_letter_list << letter_obj
		end
	end
	first_letter_list.each do |first_letter|
		first_letter.visited = true
		if search(board, first_letter, word, 1)
			board.graph.keys.each do |obj|
				obj.visited = false
			end
			return true
		else
			board.graph.keys.each do |obj|
				obj.visited = false
			end
			next
		end
	end
	false
end

def search(board, letter_obj, word, word_letter_index)
	return true if word_letter_index == word.length
	board.graph[letter_obj].each do |neighbor|
		if neighbor.visited == false && neighbor.letter == word[word_letter_index]
			if search(board, neighbor, word, word_letter_index+1)
				board.graph.keys.each do |obj|
					obj.visited = false
				end
				return true
			else
				board.graph.keys.each do |obj|
					obj.visited = false
				end
				next
			end
			next
		end
	end
	false
end

class Board

	def initialize(letter_set, board_size)
		@letter_set = letter_set
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
	attr_accessor :letter_set, :scored_words, :graph, :board_size


	# TODO -
	# def self.deterministic
	# 	@letter_set = ['t','n','w', 'p','e','r','g','e','g']
	# 	@board_size = 3
	# 	@scored_words = {}
	# end

	def display
		puts 'Available letters: '
		for i in 0...@board_size*@board_size
			if (i+1) % @board_size == 0
				puts @letter_set[i]
				puts
			else
				print @letter_set[i],' '
			end
		end
	end

	# def to_json(*args)
	# 	{
	# 		'json_class' => self.class.name,
	# 		'data' => [:display]
	# 		}.to_json(*args)
	# end
end

def get_board_size
	print 'To create an N X N Boggle board, enter N (1 to 10): '
	board_size = gets.chomp.to_i
	until board_size.kind_of?(Integer) && board_size > 2 && board_size <= 10
		print 'Please enter an integer between 3 and 10! '
		board_size = gets.chomp.to_i
		puts
	end
	board_size
end

def get_word
	print 'Enter a valid word: '
	word = gets.chomp
	puts
	word
end

def play_boggle
	puts 'Welcome to Boggle! Press . anytime to exit'
	puts

	wordlist = load_words('words.txt')
	puts

	word_score = total_score = 0

	board_size = get_board_size

	letter_set = generate_letter_set(board_size*board_size) #['t','n','w', 'p','e','r','g','e','g']
	
	board = Board.new(letter_set, board_size)
	
	while true
		board.display
		
		word = get_word

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

		if board.scored_words.has_key? word
			puts "#{word} has already been entered! Please try again."
			next
		else

			word_score = score_word(word)
			board.scored_words[word] = 1
			total_score += word_score if word_score
			puts "You scored #{word_score} points for #{word}."
			puts "Your total score is #{total_score}."
			puts
		end
	end
	puts 'Thank you for playing Boggle. Goodbye!'
end
