require 'socket'
require 'json'
require_relative 'multiplayer_bobble.rb'



def play_bobble
  #create connection
  client = TCPSocket.new('10.0.1.76', 45678)
  #puts 'client connected'
  puts
  new_board = client.readpartial(64).chomp
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
    display_board(letter_set, board_size) #display board
    #puts 'displayed board'
    word = gets #get user input for word
    break if word.chomp == '.'
    #puts "#{word}"
    client.write word #pass word to server
    #puts 'word passed on'
    puts
    puts client.readpartial(256)
    puts
    #puts 'response received'
  end
  puts 'Thank you for playing Bobble! Goodbye!'
  client.close  #close connection
end

play_bobble