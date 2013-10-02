#In Word game, the users gets a random set of letters and then constructs valid english words out of the given set.


LETTER_SCORE = {'a'=>1, 'j'=>8, 's'=>1,'b'=>3, 'k'=>5, 't'=>1, 'c'=>3, 'l'=>1, 'u'=>1, 'd'=>2, 'm'=>3, 'v'=>4, 'e'=>1, 
				'n'=>1, 'w'=>4, 'f'=>4, 'o'=>1, 'x'=>8, 'g'=>2, 'p'=>3, 'y'=>4, 'h'=>4, 'q'=>10, 'z'=>10, 'i'=>1, 'r'=>1}

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

CONSONANTS, VOWELS = generate_initial_alphabet_set

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

def generate_letter_set(num_letters)
	letter_set = []
	num_vowels = num_letters/3
	for i in 0...num_vowels
		letter_set << VOWELS.sample
	end
	for j in 0...(num_letters-num_vowels)
		letter_set << CONSONANTS.sample
	end
	letter_set.sort
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
	if word.length <= 3
		score
	elsif word.length <=6
		score*2
	elsif word.length > 6
		score*3
	end
end


def play_game
	wordlist = load_words('words.txt')
	puts
	puts "How many letters do you wish to have in your lette set?"
	num_letters = gets.chomp.to_i
	letter_set = generate_letter_set(num_letters)
	puts 'Welcome to Boggle! Press . anytime to exit.'
	puts
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
			letter_set.delete_at letter_index
		end
		word_score = score_word(word)
		total_score += word_score if word_score
		puts "You scored #{word_score} points for #{word}"
		puts "Your total score is #{total_score}"
		puts ''
	end
	puts 'Thank you for playing Boggle! Goodbye!' if word != '.'
end






