require "tmpdir"

def basedir
  File.expand_path("../../", __FILE__)
end

def beta?
  version =~ /pre/
end

def clean(file)
  rm file if File.exists?(file)
end

def component_bundle(submodule, cmd)
  Bundler.with_clean_env do
    # TODO: talked with indirect; next bundler rc will make this unset unneeded
    system "cd #{basedir}/components/#{submodule}; unset GEM_HOME RUBYOPT; bundle #{cmd}" or abort
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

def s3_connect
  return if @s3_connected

  require "aws/s3"

  unless ENV["HEROKU_RELEASE_ACCESS"] && ENV["HEROKU_RELEASE_SECRET"]
    abort("please set HEROKU_RELEASE_ACCESS and HEROKU_RELEASE_SECRET")
  end

  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV["HEROKU_RELEASE_ACCESS"],
    :secret_access_key => ENV["HEROKU_RELEASE_SECRET"]
  )

  @s3_connected = true
end

def store(package_file, filename, bucket="assets.heroku.com")
  s3_connect
  puts "storing: #{filename} in #{bucket}"
  AWS::S3::S3Object.store(filename, File.open(package_file), bucket,
                          :access => :public_read)
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
