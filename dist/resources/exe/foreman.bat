:: Don't use ECHO OFF to avoid possible change of ECHO
:: Use SETLOCAL so variables set in the script are not persisted
@SETLOCAL

:: Add bundled ruby version to the PATH, relative to this script directory.
@SET HEROKU_RUBY="%~dp0..\ruby-1.9.3\bin"
@SET PATH=%HEROKU_RUBY%;%PATH%

:: Invoke 'foreman' (the calling script) as argument to ruby.
:: Also forward all the arguments provided to it.
@ruby.exe "%~dpn0" %*