debs = ["heroku", "foreman"]

def sub_bundle(submodule, cmd)
  Bundler.with_clean_env do
    # TODO: talked with indirect; next bundler rc will make this unset unneeded
    system "cd #{submodule}; unset GEM_HOME RUBYOPT; bundle #{cmd}" or abort
  end
end

def build_deb(name)
  sub_bundle name, "install --path vendor/bundle"

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

def store(package_file, filename, bucket)
  s3_connect
  abort("Please set HEROKU_RELEASE_BUCKET") unless bucket
  puts "storing: #{filename} in #{bucket}"
  AWS::S3::S3Object.store(filename, File.open(package_file), bucket,
                          :access => :public_read)
end

desc "Clear out apt-get repository files"
task "deb:clean" do
  FileUtils.rm_rf "apt"
end

desc "Build an apt-get repository with freight"
task "deb:repository" do
  FileUtils.mkdir_p "apt"

  paths = debs.map {|dep| File.expand_path build_deb(dep) }

  Dir.chdir("apt") do
    paths.each do |path|
      FileUtils.cp(path, File.basename(path))
    end

    touch "Sources"
    sh "apt-ftparchive packages . > Packages"
    sh "gzip -c Packages > Packages.gz"
    sh "apt-ftparchive release . > Release"
    sh "gpg -abs -u 0F1B0520 -o Release.gpg Release"
  end
end

desc "Publish apt-get repository to S3."
task "deb:release" => "deb:repository" do |t|
  Find.find("apt").each do |file|
    unless File.directory?(file)
      store file, file, ENV["HEROKU_RELEASE_BUCKET"] || "heroku-toolbelt"
    end
  end
end
