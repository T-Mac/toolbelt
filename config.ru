$stdout.sync = true

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
    dir = (params[:splat] || []).reject { |p| p == "." }.join("/")
    puts "splat: #{params[:splat]}"
    puts "redirect to #{dir}"
    redirect "http://heroku-toolbelt.s3.amazonaws.com/apt/#{dir}"
  end

end

#use Rack::Static, :urls => %w( /ubuntu ), :root => "public"
run Toolbelt
