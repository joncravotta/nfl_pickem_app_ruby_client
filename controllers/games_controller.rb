require_relative '../network_client/services/games_service'
require_relative '../network_client/parser'

class GamesController < AppController

  TEST_CACHE_KEY = "test_key_01"
  def initialize
    super
  end

  get "/all" do
    content_type :json
    # request = GameService.new.get_games("2017", "09", "28")
    # games = Parser.new.parse_html(request)
    # {"data": games}.to_json
    File.read('games.json')
  end

  get "/set_cache" do
    set_cache(TEST_CACHE_KEY, "Hello, i'm cached", 60)
  end

  get "/get_cache" do
    cache = cached?(TEST_CACHE_KEY)
    cache ? cache : "CACHE FAILED"
  end

end
