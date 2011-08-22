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

  get "/download/osx" do
    haml :osx
  end

  get "/download/linux" do
    haml :linux
  end

  get "/ubuntu/*" do
    redirect "http://heroku-toolbelt.s3.amazonaws.com/apt/#{params[:splat].join("/")}"
  end

end

#use Rack::Static, :urls => %w( /ubuntu ), :root => "public"
run Toolbelt
