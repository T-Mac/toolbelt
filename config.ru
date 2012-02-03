$stdout.sync = true

require "rubygems"
require "bundler/setup"

Bundler.require(:default, ENV["RACK_ENV"])

class Toolbelt < Sinatra::Base

  configure do
    Compass.configuration do |config|
      config.project_path = File.dirname(__FILE__)
      config.sass_dir = 'views'
    end

    set :haml, { :format => :html5 }
    set :sass, Compass.sass_engine_options
  end

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
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt.exe"
  end

  get "/osx/readme" do
    haml :osx
  end

  get "/osx/download" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt.pkg"
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

use Rack::Static, :urls => %w( /apt, /images ), :root => "public"
run Toolbelt
