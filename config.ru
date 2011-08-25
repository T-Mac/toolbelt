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

  get "/windows/download" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt-beta.exe"
  end

  get "/windows/readme" do
    haml :windows
  end

  get "/osx/download" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt-beta.pkg"
  end

  get "/osx/readme" do
    haml :osx
  end

  get "/linux/download" do
    haml :linux
  end

  get "/download/windows" do
    %{
      <a href="/windows/download">Download</a>
      (<a href="/windows/readme">more info</a>)
    }
  end

  get "/download/osx" do
    %{
      <a href="/osx/download">Download</a>
      (<a href="/osx/readme">more info</a>)
    }
  end

  get "/download/linux" do
    redirect "/linux/download"
  end

  get "/ubuntu/*" do
    dir = params[:splat].first.gsub(/^\.\//, "")
    puts "splat: #{params[:splat]}"
    puts "redirect to #{dir}"
    redirect "http://heroku-toolbelt.s3.amazonaws.com/apt/#{dir}"
  end

end

use Rack::Static, :urls => %w( /apt ), :root => "public"
run Toolbelt
