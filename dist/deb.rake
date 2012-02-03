debs = ["heroku", "foreman"]

def build_deb(name)
  sub_bundle name, "install --path vendor/bundle"
  sub_bundle name, "exec rake deb:clean deb:build"
  Dir.glob("#{name}/pkg/apt*/*deb").first
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
