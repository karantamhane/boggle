#In Word game, the users gets a random set of letters and then constructs valid english words out of the given set.

#Proposed game flow - 
#*Choose random letters with a third of them being vowels and store them in a hash
#*Store letters in a hash as letter => frequency
#*Display set for user
#*Accept words from user
#*Check for validity
#*If valid, remove used letters from set and display rest of the letters
#*Score words based on letters used (through scrabble letter values stored in a hash) and length of words
#*Run till user quits. Give user option to play a new game.

LETTERS_SCORE = #letter => score value

CONSONANTS = 'bcdfghjklmnpqrstvwxyz'.split('')
VOWELS = 'aeiou'.split('')

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

#TODO
def is_word_valid?(word)
	true
end

def are_letters_available?(letter_set, word)
	word.split('').each do |letter|
		return false unless word.count(letter) <= letter_set.count(letter)
	end
	true
end

def play_game
	num_letters = 10
	letter_set = generate_letter_set(num_letters)
	while letter_set.length > 0
		puts "Available letters: ", letter_set.join('')
		puts "Enter a valid word: "
		word = gets.chomp
		unless is_word_valid?(word)
			puts "#{word} is not a valid word!"
			next
		end
		unless are_letters_available?(letter_set, word)
			puts "Only use available letters!"
			next
		end 
		#check if word is valid
		# check if all letters are available enough times
		for i in 0...word.length
			letter_index = letter_set.index(word[i])
			#print letter_index
			letter_set.delete_at(letter_index)
		end
	end
end






