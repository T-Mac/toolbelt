def assemble(source, target, perms=0644)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, "w") do |f|
    f.puts ERB.new(File.read(source)).result(binding)
  end
  File.chmod(perms, target)
end

def build_deb(name)
  rm_rf "#{component_dir(name)}/.bundle"
  rm_rf Dir["#{basedir}/components/#{name}/pkg/apt*"]
  component_bundle name, "install --path vendor/bundle"
  component_bundle name, "exec rake deb:clean deb:build"
  Dir["#{basedir}/components/#{name}/pkg/apt*/*deb"].first
end

desc "Construct repository"
file pkg("heroku-toolbelt-#{version}.apt") do |t|
  abort "Don't publish .debs of pre-releases!" if version =~ /[a-zA-Z]$/

  mkchdir(t.name) do |dir|
    cp build_deb("heroku"),  "./"
    cp build_deb("foreman"), "./"
    cp "../deb/heroku-toolbelt-#{version}.deb", "./"

    touch "Sources"

    sh "apt-ftparchive packages . > Packages"
    sh "gzip -c Packages > Packages.gz"
    sh "apt-ftparchive release . > Release"
    sh "gpg -abs -u 0F1B0520 -o Release.gpg Release"
  end
end

desc "Build metapackage"
file pkg("deb/heroku-toolbelt-#{version}.deb") do |t|
  mkchdir(File.dirname(t.name) + "/heroku-toolbelt") do
    assemble(File.expand_path("../resources/deb/control", __FILE__),
             "DEBIAN/control")
    sh "dpkg-deb --build . ../heroku-toolbelt-#{version}.deb"
  end
end

desc "Clean deb"
task "deb:clean" do
  clean pkg("heroku-toolbelt-#{version}.apt")
  clean pkg("heroku-toolbelt-#{version}.deb")
  clean pkg("deb")
end

desc "Build repository and metapackage"
task "deb:repository" => [pkg("deb/heroku-toolbelt-#{version}.deb"),
                          pkg("heroku-toolbelt-#{version}.apt")]

desc "Release deb"
task "deb:release" => "deb:repository" do |t|
  Dir[File.join(pkg("heroku-toolbelt-#{version}.apt"), "**", "*")].each do |file|
    unless File.directory?(file)
      remote = file.gsub(pkg("heroku-toolbelt-#{version}.apt"), "apt")
      store file, remote, "heroku-toolbelt"
    end
  end
end
