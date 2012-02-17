require "erb"

def build_zip(name)
  component_bundle name, "install --path vendor/bundle"
  component_bundle name, "exec rake zip:clean zip:build"
  Dir.glob("#{basedir}/components/#{name}/pkg/*.zip").first
end

def extract_zip(filename, destination)
  tempdir do |dir|
    sh %{ unzip #{filename} }
    sh %{ mv * #{destination} }
  end
end

file pkg("heroku-toolbelt-#{version}.exe") do |t|
  tempdir do |dir|
    mkdir_p "#{dir}/heroku"
    extract_zip build_zip("heroku"), "#{dir}/heroku/"

    mkchdir("installers") do
      system "curl http://heroku-toolbelt.s3.amazonaws.com/rubyinstaller.exe -o rubyinstaller.exe"
      system "curl http://heroku-toolbelt.s3.amazonaws.com/git.exe -o git.exe"
    end

    cp resource("exe/heroku.bat"), "heroku/bin/heroku.bat"
    cp resource("exe/heroku"),     "heroku/bin/heroku"

    File.open("heroku.iss", "w") do |iss|
      iss.write(ERB.new(File.read(resource("exe/heroku.iss"))).result(binding))
    end

    inno_dir = ENV["INNO_DIR"] || 'C:\\Program Files (x86)\\Inno Setup 5\\'

    system "\"#{inno_dir}\\Compil32.exe\" /cc \"heroku.iss\""
  end
end

desc "Clean exe"
task "exe:clean" do
  clean pkg("heroku-toolbelt-#{version}.exe")
end

desc "Build exe"
task "exe:build" => pkg("heroku-toolbelt-#{version}.exe")

desc "Release exe"
task "exe:release" => "exe:build" do |t|
  store pkg("heroku-toolbelt-#{version}.exe"), "heroku-toolbelt/heroku-toolbelt-#{version}.exe"
  store pkg("heroku-toolbelt-#{version}.exe"), "heroku-toolbelt/heroku-toolbelt-beta.exe" if beta?
  store pkg("heroku-toolbelt-#{version}.exe"), "heroku-toolbelt/heroku-toolbelt.exe" unless beta?
end
