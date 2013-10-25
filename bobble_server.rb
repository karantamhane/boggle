require 'socket'
require 'json'
require_relative 'bobble.rb'


def start_server_single#
  #create server socket
  server = TCPServer.new('0.0.0.0', 45679)
  
  loop do |c = server.accept| #create accept loop for server
    #puts 'connection accepted'
    Thread.start(c) do |conn| #create thread for each game
      #puts 'thread started'
      board_size = conn.readpartial(512).to_i #get board size from client
      letter_set = generate_letter_set board_size*board_size #generate letter set
      
      conn.write letter_set.to_json #pass letter set to client
      
      board = Board.new(letter_set, board_size) #create board object for current game
      #puts 'board created'
      wordlist = load_words('words.txt') #load wordlist
      #puts 'wordlist loaded'
      puts

      total_score = 0
      word_score = 0
      while true #perform game computations
        word = conn.readpartial(64).chomp
        break if word == '.'
        #puts 'word received', word
        unless is_word_valid?(word, wordlist)
          conn.write "#{word} is not a valid word!"
          next
        end
        #puts 'word valid'

        unless are_letters_available?(letter_set, word)
          conn.write 'Only use available letters!'
          next
        end
        #puts 'letters available'

        unless word_path_valid_on_board?(word, board)
          conn.write "A word is valid only if it traces a pattern on the current board! Please try again."
          next
        end
        #puts 'word path found'

        #puts board.scored_words
        if board.scored_words.has_key? word
          conn.write "#{word} has already been entered! Please try again."
          next
        else
          word_score = score_word(word)
          board.scored_words[word] = 1
          total_score += word_score if word_score
          conn.write "You scored #{word_score} points for #{word}. Your total score is #{total_score}."
        end
      end
      #puts 'while ended'
    end
  end    
end

#start_server