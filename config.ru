require './app'
require './controllers/games_controller'
map('/games') { run GamesController }
run Sinatra::Application
