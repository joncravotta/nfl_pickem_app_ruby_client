require 'sinatra/base'
require 'sinatra/json'

class AppController < Sinatra::Base
  #map('app') { run "Hello World" }
  get '/test' do
      'Put this in your pipe & smoke it!'
  end
end
