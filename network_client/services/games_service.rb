require_relative './../client'

class GameService < Client

  def get_games(year, month, date)
    get_request(construct_url(year, month, date))
  end

  private

  def construct_url(year, month, date)
    return "http://www.covers.com/Sports/NFL/Matchups?selectedDate=#{year}-#{month}-#{date}"
  end
end
