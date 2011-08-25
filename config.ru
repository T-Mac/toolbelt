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

  get "/windows/readme" do
    haml :windows
  end

  get "/windows/download" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt-beta.exe"
  end

  get "/osx/readme" do
    haml :osx
  end

  get "/osx/download" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt-beta.pkg"
  end

  get "/linux/readme" do
    haml :linux
  end

  get "/linux/download" do
    redirect "/linux/readme"
  end

  get "/ubuntu/*" do
    dir = params[:splat].first.gsub(/^\.\//, "")
    puts "splat: #{params[:splat]}"
    puts "redirect to #{dir}"
    redirect "http://heroku-toolbelt.s3.amazonaws.com/apt/#{dir}"
  end

  ### Redirects for private beta list subscribers
  get("/download/osx")       { redirect "/osx/readme" }
  get("/download/windows")   { redirect "/windows/readme" }
end

use Rack::Static, :urls => %w( /apt ), :root => "public"
run Toolbelt
