require "erb"

def build_zip(name)
  rm_rf "#{component_dir(name)}/.bundle"
  rm_rf Dir["#{basedir}/components/#{name}/pkg/*.zip"]
  component_bundle name, "install --without \"development\""
  component_bundle name, "exec rake zip:clean zip:build"
  Dir["#{basedir}/components/#{name}/pkg/*.zip"].first
end

def extract_zip(filename, destination)
  tempdir do |dir|
    sh %{ unzip "#{filename}" }
    sh %{ mv * "#{destination}" }
  end
end

file pkg("heroku-toolbelt-#{version}.exe") do |t|
  tempdir do |dir|
    mkdir_p "#{dir}/heroku"
    extract_zip build_zip("heroku"), "#{dir}/heroku/"

    mkchdir("installers") do
      ["rubyinstaller.exe", "git.exe"].each do |i|
        cache = File.join(File.dirname(__FILE__), "..", ".cache", i)
        FileUtils.mkdir_p File.dirname(cache)
        unless File.exists? cache
          system "curl http://heroku-toolbelt.s3.amazonaws.com/#{i} -o \"#{cache}\""
        end
        cp cache, i
      end
    end

    cp resource("exe/heroku.bat"), "heroku/bin/heroku.bat"
    cp resource("exe/heroku"),     "heroku/bin/heroku"

    File.open("heroku.iss", "w") do |iss|
      iss.write(ERB.new(File.read(resource("exe/heroku.iss"))).result(binding))
    end

    inno_dir = ENV["INNO_DIR"] || 'C:\\Program Files (x86)\\Inno Setup 5\\'
    signtool = ENV["SIGNTOOL"] || 'C:\\Program Files\\Microsoft SDKs\\Windows\\v7.1\\Bin\\signtool.exe'
    cert     = ENV["CERT"]     || "#{File.dirname(__FILE__)}\\..\\Certificates.p12"
    password = ENV["CERT_PASSWORD"]
    # TODO: can't have a space in the certificate path; keeping it in C: root sucks
    sign_with = "/sStandard=#{signtool} sign /d Heroku-Toolbelt /f C:\\Certificates.p12 /v /p #{password} $f"
    system "\"#{inno_dir}\\iscc\" \"#{sign_with}\" /cc \"heroku.iss\""
  end
end

desc "Clean exe"
task "exe:clean" do
  clean pkg("heroku-toolbelt-#{version}.exe")
  clean File.join(File.dirname(__FILE__), "..", ".cache")
end

desc "Build exe"
task "exe:build" => pkg("heroku-toolbelt-#{version}.exe")

desc "Release exe"
task "exe:release" => "exe:build" do |t|
  store pkg("heroku-toolbelt-#{version}.exe"), "heroku-toolbelt/heroku-toolbelt-#{version}.exe"
  store pkg("heroku-toolbelt-#{version}.exe"), "heroku-toolbelt/heroku-toolbelt-beta.exe" if beta?
  store pkg("heroku-toolbelt-#{version}.exe"), "heroku-toolbelt/heroku-toolbelt.exe" unless beta?
end
