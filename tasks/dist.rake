require "fog"
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
  Dir.chdir "#{basedir}/components/#{submodule}" do
    Bundler.with_clean_env do
      sh "export"
      sh "bundle #{cmd}" or abort
    end
  end
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
  unless ENV["HEROKU_RELEASE_ACCESS"] && ENV["HEROKU_RELEASE_SECRET"]
    abort("please set HEROKU_RELEASE_ACCESS and HEROKU_RELEASE_SECRET")
  end

  @s3 ||= Fog::Storage.new(
    :provider              => :aws,
    :aws_access_key_id     => ENV["HEROKU_RELEASE_ACCESS"],
    :aws_secret_access_key => ENV["HEROKU_RELEASE_SECRET"]
  )
end

def store(local, remote, bucket="assets.heroku.com")
  puts "storing: %s/%s" % [ bucket, remote ]
  dir = s3
  parts = remote.split("/")
  remote_filename = parts.pop
  begin
    parts.each { |part| dir = dir.directories.get(part) }
  rescue
    abort "couldnt find directory: #{parts.join("/")}"
  end
  dir.files.create(:key => remote, :body => File.open(local), :public => true)
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

Dir[File.expand_path("../../dist/**/*.rake", __FILE__)].each do |rake|
  import rake
end
