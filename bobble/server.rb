require 'socket'
require_relative 'player.rb'
require_relative 'session.rb'

#ASk for single/multiplayer
def start_server
  server = TCPServer.new('0.0.0.0', 45678)
  sessions = []
  loop do
    connection = server.accept

    player = Player.new
    connection.puts 'Do you wish to start a multiplayer game, yes/no?'
    multiplayer = connection.gets.chomp
    if sessions.empty? || multiplayer == 'no' || sessions.last.player_limit_reached? || sessions.last.abandoned?
      session = Session.new player
      session.num_players = 1 if multiplayer == 'no'
      sessions << session if multiplayer != 'no'
    else
      session = sessions.last
      session.add_player player
    end
    player.session = session
    player.start_thread connection
  end
end
start_server