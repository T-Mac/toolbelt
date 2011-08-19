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

use Rack::Static, :urls => %w( /ubuntu ), :root => "public"
run Toolbelt
