debs = ["heroku", "foreman"]

def build_deb(name)
  path = "#{File.dirname(__FILE__)}/../#{name}"
  raise "Dependency not checked out: #{path}" if !File.exists? path
  # TODO: got to be a cleaner way to do this
  bundle_unset = "GEM_PATH GEM_HOME BUNDLE_BIN_BATH BUNDLE_GEMFILE"
  system "cd #{path}; unset #{bundle_unset}; bundle exec rake deb:clean deb:build" or abort
  Dir.glob("#{path}/pkg/apt*/*deb").first
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

# echo "deb http://packages.rcrowley.org $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/rcrowley.list
# sudo wget -O /etc/apt/trusted.gpg.d/rcrowley.gpg http://packages.rcrowley.org/keyring.gpg
# sudo apt-get update && sudo apt-get -y install freight
desc "Publish apt-get repository to S3."
task "deb:release" => "deb:repository" do |t|
  Find.find("freight").each do |file|
    unless File.directory?(file)
      store file, "apt/#{file.sub(/freight\//, '')}", ENV["HEROKU_RELEASE_BUCKET"]
    end
  end
end

# To use:
# echo "deb http://crazybukkit.s3.amazonaws.com/apt debian main" | sudo tee /etc/apt/sources.list.d/rcrowley.list
# sudo wget -O /etc/apt/trusted.gpg.d/heroku.gpg http://crazybukkit.s3.amazonaws.com/apt/pubkey.gpg
# sudo apt-get update && sudo apt-get -y install heroku-toolbelt
