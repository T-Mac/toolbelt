require "rubygems"
require "bundler/setup"

Bundler.require(:default, ENV["RACK_ENV"])

class Toolbelt < Sinatra::Base

  get "/" do
    haml :index
  end

  get "/toolbelt.css" do
    sass :toolbelt
  end

  get "/download/windows" do
    redirect "http://assets.heroku.com/heroku-client/heroku-setup.exe"
  end

end

use Rack::Static, :root => File.expand_path("../public", __FILE__)
run Toolbelt
