debs = ["heroku", "foreman"]

def sub_bundle(submodule, cmd)
  Bundler.with_clean_env do
    system "cd #{submodule}; bundle #{cmd}" or abort
  end
end

def build_deb(name)
  unless File.exist? name + "/vendor/bundle"
    # AFAICT this is broken due to a bug in Bundler
    # sub_bundle name, "install --path vendor/bundle"
    abort "Need to manually run bundle install in #{name} due to bundler bug"
  end

  sub_bundle name, "exec rake deb:clean deb:build"
  Dir.glob("#{name}/pkg/apt*/*deb").first
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

def store(package_file, filename, bucket=ENV["HEROKU_RELEASE_BUCKET"])
  s3_connect
  puts "storing: #{filename} in #{bucket}"
  AWS::S3::S3Object.store(filename, File.open(package_file), bucket,
                          :access => :public_read)
end

desc "Clear out apt-get repository files"
task "deb:clean" do
  FileUtils.rm_rf "freight-lib"
  FileUtils.rm_rf "freight"
end

desc "Build an apt-get repository with freight"
task "deb:repository" do
  debs.each do |dep|
    deb_path = build_deb dep
    system "echo $PWD"
    system "freight add -c $PWD/freight.conf #{deb_path} apt/debian"
  end
  system "freight cache -c $PWD/freight.conf"
  # Symlinks don't translate to S3
  File.delete "freight/dists/debian"
  File.rename Dir.glob("freight/dists/debian-*").first, "freight/dists/debian"
end

desc "Publish apt-get repository to S3."
task "deb:release" => "deb:repository" do |t|
  if ! system "which freight > /dev/null"
    abort "Need freight installed: https://github.com/rcrowley/freight#readme"
  end

  Find.find("freight").each do |file|
    unless File.directory?(file)
      store file, "apt/#{file.sub(/freight\//, '')}"
    end
  end
end
