require_relative '../network_client/services/games_service'
require_relative '../network_client/parser'


class GamesController < AppController

  def initialize
    super
  end

  get "/games" do
    content_type :json
    request = GameService.new.get_games("2017", "09", "28")
    games = Parser.new.parse_html(request)
    {"data": games}.to_json
  end

end
