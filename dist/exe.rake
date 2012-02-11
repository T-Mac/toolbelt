file pkg("heroku-#{version}.exe") do |t|
  tempdir do |dir|
    mkchdir("installers") do
      system "curl http://heroku-toolbelt.s3.amazonaws.com/rubyinstaller.exe -o rubyinstaller.exe"
      system "curl http://heroku-toolbelt.s3.amazonaws.com/git.exe -o git.exe"
    end

    File.open("heroku.iss", "w") do |iss|
      iss.write(ERB.new(File.read(resource("exe/heroku.iss"))).result(binding))
    end

    inno_dir = ENV["INNO_DIR"] || 'C:\\Program Files (x86)\\Inno Setup 5\\'

    system "\"#{inno_dir}\\Compil32.exe\" /cc \"heroku.iss\""
  end
end

desc "Clean exe"
task "exe:clean" do
  clean pkg("heroku-#{version}.exe")
end

desc "Build exe"
task "exe:build" => pkg("heroku-#{version}.exe")

desc "Publish exe to S3."
task "exe:release" => "exe:build" do |t|
  # store pkg("heroku-toolbelt-#{version}.pkg"), "heroku-toolbelt/heroku-toolbelt-#{version}.pkg"
  # store pkg("heroku-toolbelt-#{version}.pkg"), "heroku-toolbelt/heroku-toolbelt-beta.pkg" if beta?
  # store pkg("heroku-toolbelt-#{version}.pkg"), "heroku-toolbelt/heroku-toolbelt.pkg" unless beta?
end
