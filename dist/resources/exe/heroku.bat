@echo OFF

:: determine if this is an NT operating system
if not "%~f0" == "~f0" goto WinNT
goto Win9x

:Win9x
@"HEROKUPATH\ruby-1.9.3\bin\ruby.exe" "HEROKUPATH\heroku" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto :EOF

:WinNT
@"HEROKUPATH\ruby-1.9.3\bin\ruby.exe" "HEROKUPATH\heroku" %*
goto :EOF
