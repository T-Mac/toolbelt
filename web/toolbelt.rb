ENV["HEROKU_NAV_URL"] = "https://nav.heroku.com/v2"

require "compass"
require "rdiscount"
require "heroku/nav"
require "sinatra"

class Toolbelt < Sinatra::Base

  use Heroku::Nav::Header

  configure do
    Compass.configuration do |config|
      config.project_path = File.dirname(__FILE__)
      config.sass_dir = 'views'
    end

    set :haml, { :format => :html5 }
    set :sass, Compass.sass_engine_options
    set :static, true
    set :root, File.expand_path("../", __FILE__)
    set :views, File.expand_path("../views", __FILE__)
  end

  configure :production do
    require "rack-ssl-enforcer"
    use Rack::SslEnforcer
  end

  helpers do
    def markdown_plus(partial, opts={})
      content = markdown(partial, opts)

      content.gsub(/<code>(.*?)<\/code>/m) do |match|
        match.gsub(/\$(.*)\n/, "<span class=\"highlight\">$\\1</span>\n")
      end
    end

    def newest_mtime
      @newest_mtime ||= begin
        Dir[File.join(settings.views, "**")].map do |file|
          File.mtime(file)
        end.sort.last
      end
    end

    def useragent_platform
      case request.user_agent
        when /Mac OS X/ then :osx
        when /Linux/    then :linux
        when /Windows/  then :windows
        else                 :osx
      end
    end
  end

  get "/" do
    last_modified newest_mtime
    haml :index, :locals => { :platform => useragent_platform }
  end

  %w( osx windows linux ).each do |platform|
    get "/#{platform}" do
      if request.xhr?
        markdown_plus platform.to_sym
      else
        last_modified newest_mtime
        haml :index, :locals => { :platform => platform.to_sym }
      end
    end
  end

  get "/:name.css" do
    last_modified newest_mtime
    sass params[:name].to_sym rescue not_found
  end

  # apt repository
  get "/ubuntu/*" do
    dir = params[:splat].first.gsub(/^\.\//, "")
    redirect "http://heroku-toolbelt.s3.amazonaws.com/apt/#{dir}"
  end

  get "/download/windows" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt.exe"
  end

  get "/download/osx" do
    redirect "http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt.pkg"
  end

  # linux install instructions
  get "/install.sh" do
    content_type "text/plain"
    erb :install
  end

  # legacy redirects
  get("/osx/download")     { redirect "/osx"     }
  get("/windows/download") { redirect "/windows" }
  get("/linux/readme")     { redirect "/linux"   }
end
