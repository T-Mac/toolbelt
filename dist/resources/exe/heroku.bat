@ECHO OFF

:: determine if this is x86 or x64
if "%ProgramFiles%" == "%ProgramW6432%" goto x64
goto x86

:x86
set HerokuRubyPath=%ProgramFiles%\ruby-1.9.3
goto launch

:x64
set HerokuRubyPath=%ProgramFiles(x86)%\ruby-1.9.3
goto launch

:launch

:: determine if this is an NT operating system
if not "%~f0" == "~f0" goto WinNT
goto Win9x

:Win9x
@"%HerokuRubyPath%\bin\ruby.exe" "heroku" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto :EOF

:WinNT
@"%HerokuRubyPath%\bin\ruby.exe" "%~dpn0" %*
goto :EOF
