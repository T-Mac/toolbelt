require "erb"

pkgs = %w( heroku foreman )

def build_pkg(name)
  sub_bundle name, "install --path vendor/bundle"
  sub_bundle name, "exec rake pkg:clean pkg:build"
  Dir.glob("#{basedir}/components/#{name}/pkg/*.pkg").first
end

def extract_pkg(filename, destination)
  tempdir do |dir|
    sh %{ pkgutil --expand #{filename} pkg }
    sh %{ mv pkg/*.pkg #{destination} }
  end
end

desc "Clean pkg"
task "pkg:clean" do
  %x{ rm -rf pkg/*.pkg }
end

desc "Build pkg"
task "pkg:build" do
  tempdir do |dir|
    mkdir_p "pkg"
    mkdir_p "pkg/Resources"

    extract_pkg build_pkg("heroku"), "#{dir}/pkg"
    extract_pkg build_pkg("foreman"), "#{dir}/pkg"

    kbytes = %x{ du -ks pkg | cut -f 1 }
    num_files = %x{ find pkg | wc -l }

    sh %{ curl http://heroku-toolbelt.s3.amazonaws.com/git.pkg -o git-full.pkg }
    sh %{ pkgutil --expand git-full.pkg git-full }
    mv "git-full/etc.pkg", "pkg/git-etc.pkg"
    mv "git-full/git.pkg", "pkg/git-git.pkg"

    dist = File.read(resource("pkg/Distribution.erb"))
    dist = ERB.new(dist).result(binding)
    File.open("pkg/Distribution", "w") { |f| f.puts dist }

    sh %{ pkgutil --flatten pkg heroku-toolbelt-#{version}.pkg }

    cp_r "heroku-toolbelt-#{version}.pkg", pkg("heroku-toolbelt-#{version}.pkg")
  end
end

desc "Publish pkg to S3."
task "pkg:release" => "pkg:build" do |t|
  store pkg("heroku-toolbelt-#{version}.pkg"), "heroku-toolbelt/heroku-toolbelt-#{version}.pkg"
  store pkg("heroku-toolbelt-#{version}.pkg"), "heroku-toolbelt/heroku-toolbelt-beta.pkg" if beta?
  store pkg("heroku-toolbelt-#{version}.pkg"), "heroku-toolbelt/heroku-toolbelt.pkg" unless beta?
end
