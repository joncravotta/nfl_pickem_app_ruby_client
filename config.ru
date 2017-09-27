require './app'
require './controllers/games_controller'
map('/app') { run GamesController }
run Sinatra::Application
