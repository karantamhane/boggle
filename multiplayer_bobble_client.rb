require 'socket'
require 'json'
require_relative 'multiplayer_bobble.rb'
require_relative 'bobble_client.rb'

def select_client
  print 'Do you wish to start a multiplayer game, yes/no? '
  multi = gets
  client = TCPSocket.new('localhost',45677)
  client.write multi
  client.close
  if multi.chomp == 'no'
    #puts 'single client'
    play_bobble_single
  else
    #puts 'multi client'
    play_bobble_multi
  end
end

def play_bobble_multi
  begin
    client = TCPSocket.new('localhost', 45678) #create connection
  rescue
    retry
  end

  print 'Enter your name: '
  client.write gets #get player name
  puts
  new_board = client.readpartial(64).chomp #check if new board to be generated
  #puts "new_board is #{new_board}"
  if new_board == 'true'
    board_size = get_board_size #get user input for board size
    client.write board_size #send board size to server
  else
    board_size = new_board.to_i
    #puts 'got board size from server'
  end

  letter_set = JSON.parse client.readpartial(512) #get letter set from server
  
  puts
  puts 'Welcome to Bobble! Press . anytime to exit'
  puts  

  #Start game
  word = ''
  
  while true
    begin
      display_board(letter_set, board_size) #display board
      print 'Enter word: '
      word = gets #get user input for word
      client.write word
      puts
      
      break if word.chomp == '.'
      
      puts client.readpartial(256)
      #puts 'response received'
    rescue
      puts 'Your opponent forfeits! You win!'
      break
    end
  end
  puts 'You forfeit! Your opponent wins!' if word.chomp == '.'  
  puts 'Thank you for playing Bobble! Goodbye!'
  client.close  #close connection
end

#play_bobble
select_client