require 'socket'

client = TCPSocket.new('10.0.1.76', 45678)

def is_session_new? client
  #puts 'checking if session is new'
  return client.gets.chomp == 'new_session'
end

def enter_num_players client
  puts client.gets.chomp
  num_players = gets.chomp.to_i
  puts
  until num_players.kind_of?(Integer) && num_players > 1 && num_players <= 4
    puts 'Enter an integer from 2 to 4!'
    num_players = gets.chomp.to_i
  end
  client.puts num_players
  num_players
end

def enter_board_size client
  puts client.gets.chomp
  board_size = gets.chomp.to_i
  puts
  until board_size.kind_of?(Integer) && board_size > 2 && board_size <= 10
    print 'Please enter an integer between 3 and 10! '
    board_size = gets.chomp.to_i
    puts
  end
  client.puts board_size
end

def enter_name client
  puts client.gets
  print client.gets.chomp
  client.puts gets
end

def get_board_size_client client
  client.gets.chomp.to_i
end

def display_game_board client, board_size
  puts 'Available letters: '
  for i in 0...board_size*board_size
    if (i+1)% board_size == 0
      puts client.gets.chomp
      puts
    else
      print client.gets.chomp + ' '
    end
  end
end

def send_word_to_server client
  print 'Enter valid word: '
  client.puts gets
end

def play_game client
  begin
    puts client.gets.chomp
    multiplayer = gets.chomp
    unless ['yes', 'no'].include? multiplayer
      raise Errno
    end
  rescue
    puts 'Please enter yes or no.'
    multiplayer = gets.chomp
    retry
  end
  client.puts multiplayer

  enter_name client
  #print 'Do you wish to start a multiplayer game, yes/no? '
  if is_session_new? client
    #puts 'session is new'
    if multiplayer != 'no'
      num_players = enter_num_players client
    else
      num_players = 1
    end
    enter_board_size client
  end
  puts 'Waiting for other players...' if num_players > 1
  while true
    break if client.gets.chomp == 'true' #break if player limit reached
  end
  board_size = get_board_size_client client

  begin
    while true
      display_game_board client, board_size
      send_word_to_server client
      response = client.gets.chomp
      break if response == 'quitter' || response == 'timeout'
      puts response
    end
    #puts " response is #{response}"
    if response == 'quitter'
      puts 'You forfeit!'
      puts 'Thank you for playing Bobble! Goodbye!'
      client.close
    else
      puts 'Sorry! You are out of time..!'
      puts client.gets.chomp
    end
  end
end
play_game client





