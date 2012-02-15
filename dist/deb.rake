debs = ["heroku", "foreman"]

def build_deb(name)
  component_bundle name, "install --path vendor/bundle"
  component_bundle name, "exec rake deb:clean deb:build"
  Dir.glob("#{basedir}/components/#{name}/pkg/apt*/*deb").first
end

desc "Build an apt-get repository with freight"
file pkg("heroku-#{version}.apt") do
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

desc "Clean deb"
task "deb:clean" do
  clean pkg("heroku-#{version}.apt")
end

desc "Build deb"
task "deb:build" => pkg("heroku-#{version}.apt")

desc "Release deb"
task "deb:release" => "deb:repository" do |t|
  Dir[File.join(pkg("heroku-#{version}.apt"), "**", "*")].each do |file|
    unless File.directory?(file)
      store file, file
    end
  end
end
