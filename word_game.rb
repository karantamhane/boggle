#In Word game, the users gets a random set of letters and then constructs valid english words out of the given set.

#Proposed game flow - 
#*Choose random letters with a third of them being vowels and store them in a hash
#*Store letters in a list (game is small enough to use list and avoid hash overhead)
#*Display set for user
#*Accept words from user
#*Check for validity
#*If valid, remove used letters from set and display rest of the letters
#*Score words based on letters used (through scrabble letter values stored in a hash) and length of words
#*Run till user quits. Give user option to play a new game.

LETTERS_SCORE = #letter => score value

CONSONANTS = 'bcdfghjklmnpqrstvwxyz'.split('')
VOWELS = 'aeiou'.split('')

LETTER_SCORE = {'a'=>1, 'j'=>8, 's'=>1,'b'=>3, 'k'=>5, 't'=>1, 'c'=>3, 'l'=>1, 'u'=>1, 'd'=>2, 'm'=>3, 'v'=>4, 'e'=>1, 
				'n'=>1, 'w'=>4, 'f'=>4, 'o'=>1, 'x'=>8, 'g'=>2, 'p'=>3, 'y'=>4, 'h'=>4, 'q'=>10, 'z'=>10, 'i'=>1, 'r'=>1}

def load_words(filename)
	puts 'Loading wordlist...'
	wordlist = {}
	file = open(filename, mode = 'r')
	file.each do |line|
		wordlist[line.chomp] = 1
	end
	puts 'Word list loaded successfully!'
	wordlist
end

#TODO - add frequency with weighting for letters
def generate_letter_set(num_letters)
	letter_set = []
	num_vowels = num_letters/3
	for i in 0...num_vowels
		letter_set << VOWELS.sample
	end
	for j in 0...(num_letters-num_vowels)
		letter_set << CONSONANTS.sample
	end
	return letter_set.sort
end

def is_word_valid?(word, wordlist)
	return true if wordlist.include? word
	false
end

def are_letters_available?(letter_set, word)
	word.split('').each do |letter|
		return false unless word.count(letter) <= letter_set.count(letter)
	end
	true
end

def score_word(word)
	score = 0
	word.split('').each do |letter|
		score += LETTER_SCORE[letter]
	end
	score
end

def play_game
	wordlist = load_words('words.txt')
	num_letters = 10
	letter_set = generate_letter_set(num_letters)
	puts 'Welcome to Word Game! Press . anytime to exit.'
	total_score = 0
	while letter_set.length > 0
		puts "Available letters: ", letter_set.join(' ')
		puts "Enter a valid word: "
		word = gets.chomp
		if word == '.'
			puts 'Thank you for playing Boggle! Goodbye!'
			break
		end
		unless is_word_valid?(word, wordlist)
			puts "#{word} is not a valid word!"
			next
		end
		unless are_letters_available?(letter_set, word)
			puts "Only use available letters!"
			next
		end 
		for i in 0...word.length
			letter_index = letter_set.index(word[i])
			#print letter_index
			letter_set.delete_at letter_index
		end
		word_score = score_word(word)
		total_score += word_score if word_score
		puts "You scored #{word_score} points for #{word}"
		puts "Your total score is #{total_score}"
		puts ''
	end
	puts 'Thank you for playing Boggle! Goodbye!'
end






