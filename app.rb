require 'sinatra/base'
require 'sinatra/json'

class AppController < Sinatra::Base

  def initialize
    if self.class.development?
      @cache = setup_memcache_dev
    else
      @cache = setup_memcache_prod
    end

    super
  end

  def cached?(key)
    get_cache(key)
  end

  def set_cache(key, value, time)
    @cache.set(key, value, time)
  end
  
  private

  def get_cache(key)
    @cache.get(key)
  end

  def setup_memcache_prod
    Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"],
                     :failover => true,
                     :socket_timeout => 1.5,
                     :socket_failure_delay => 0.2
                    })
  end

  def setup_memcache_dev
    options = { :namespace => "app_v1", :compress => true }
    Dalli::Client.new('localhost:11211', options)
  end
end
