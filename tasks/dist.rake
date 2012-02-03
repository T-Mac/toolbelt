def sub_bundle(submodule, cmd)
  Bundler.with_clean_env do
    # TODO: talked with indirect; next bundler rc will make this unset unneeded
    system "cd components/#{submodule}; unset GEM_HOME RUBYOPT; bundle #{cmd}" or abort
  end
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

def store(package_file, filename, bucket)
  s3_connect
  abort("Please set HEROKU_RELEASE_BUCKET") unless bucket
  puts "storing: #{filename} in #{bucket}"
  AWS::S3::S3Object.store(filename, File.open(package_file), bucket,
                          :access => :public_read)
end

Dir[File.expand_path("../../dist/**/*.rake", __FILE__)].each do |rake|
  import rake
end
