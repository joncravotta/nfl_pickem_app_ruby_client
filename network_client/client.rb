require 'httparty'

class Client
  def get_request(url)
    HTTParty.get(url)
  end
end
