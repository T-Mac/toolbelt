def build_deb(name)
  component_bundle name, "install --path vendor/bundle"
  component_bundle name, "exec rake deb:clean deb:build"
  Dir["#{basedir}/components/#{name}/pkg/apt*/*deb"].first
end

desc "Build deb"
file pkg("heroku-toolbelt-#{version}.apt") do |t|
  mkchdir(t.name) do |dir|
    cp build_deb("heroku"),  "./"
    cp build_deb("foreman"), "./"

    touch "Sources"

    sh "apt-ftparchive packages . > Packages"
    sh "gzip -c Packages > Packages.gz"
    sh "apt-ftparchive release . > Release"
    sh "gpg -abs -u 0F1B0520 -o Release.gpg Release"
  end
end

desc "Clean deb"
task "deb:clean" do
  clean pkg("heroku-toolbelt-#{version}.apt")
end

desc "Build deb"
task "deb:build" => pkg("heroku-toolbelt-#{version}.apt")

desc "Release deb"
task "deb:release" => "deb:build" do |t|
  Dir[File.join(pkg("heroku-toolbelt-#{version}.apt"), "**", "*")].each do |file|
    unless File.directory?(file)
      remote = file.gsub(pkg("heroku-toolbelt-#{version}.apt"), "apt")
      store file, remote, "heroku-toolbelt"
    end
  end
end
