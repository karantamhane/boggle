LETTER_SCORE = {'a'=>1, 'j'=>8, 's'=>1,'b'=>3, 'k'=>5, 't'=>1, 'c'=>3, 'l'=>1, 'u'=>1, 'd'=>2, 'm'=>3, 'v'=>4, 'e'=>1, 
        'n'=>1, 'w'=>4, 'f'=>4, 'o'=>1, 'x'=>8, 'g'=>2, 'p'=>3, 'y'=>4, 'h'=>4, 'q'=>10, 'z'=>10, 'i'=>1, 'r'=>1}

def load_words filename
  puts 'Loading wordlist...'
  wordlist = {}
  file = open(filename, mode = 'r')
  file.each do |line|
    wordlist[line.chomp] = 1
  end
  puts 'Word list loaded successfully!'
  wordlist
end

