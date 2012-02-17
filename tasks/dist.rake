require "tmpdir"

def basedir
  File.expand_path("../../", __FILE__)
end

def beta?
  version =~ /pre/
end

def clean(file)
  rm_rf file if File.exists?(file)
end

def component_bundle(submodule, cmd)
  Bundler.with_clean_env do
    Dir.chdir(component_dir(submodule)) do
      if windows?
        sh "set BUNDLE_BIN_PATH=&& set BUNDLE_GEMFILE=&& set GEM_HOME=&& set RUBYOPT=&& bundle #{cmd}" or abort
      else
        sh "unset GEM_HOME RUBYOPT; bundle #{cmd}" or abort
      end
    end
  end
end

def component_dir(submodule)
  File.join(basedir, "components", submodule)
end

def resource(name)
  File.expand_path("../../dist/resources/#{name}", __FILE__)
end

def mkchdir(dir)
  FileUtils.mkdir_p(dir)
  Dir.chdir(dir) do |dir|
    yield(File.expand_path(dir))
  end
end

def pkg(filename)
  FileUtils.mkdir_p("#{basedir}/pkg")
  "#{basedir}/pkg/#{filename}"
end

def s3
  @s3 ||= begin
    require 'fog'

    unless ENV["HEROKU_RELEASE_ACCESS"] && ENV["HEROKU_RELEASE_SECRET"]
      abort("please set HEROKU_RELEASE_ACCESS and HEROKU_RELEASE_SECRET")
    end

    Fog::Storage.new(
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["HEROKU_RELEASE_ACCESS"],
      :aws_secret_access_key  => ENV["HEROKU_RELEASE_SECRET"]
    )
  end
end

def store(local, remote, bucket="assets.heroku.com")
  puts "storing: #{bucket}/#{remote}"
  directory = s3.directories.new(:key => bucket)
  directory.files.create(
    :key    => remote,
    :body   => File.open(local),
    :public => true
  )
end

def tempdir
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      yield(dir)
    end
  end
end

def version
  @version ||= %x{ ruby -r#{basedir}/components/heroku/lib/heroku/version.rb -e "puts Heroku::VERSION" }.chomp
end

def windows?
  defined?(RUBY_PLATFORM) and RUBY_PLATFORM =~ /(win|w)32$/
end

Dir[File.expand_path("../../dist/**/*.rake", __FILE__)].each do |rake|
  import rake
end
