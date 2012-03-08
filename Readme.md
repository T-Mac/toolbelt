# Heroku Toolbelt

The Heroku Toolbelt is a package of the Heroku CLI, Foreman, and Git —
all the tools you need to get started using Heroku at the command
line. The Toolbelt is available as a native installer for OS X and
Windows, and is available from an apt-get repository for Debian/Ubuntu
Linux.

This repository serves two purposes: 0) a static site with
instructions and downloads for the toolbelt packages and 1) tasks
to perform the packaging itself. The `bin/web` script will launch the
web site, while the packaging is handled with rake.

# Packaging

First pull in the dependencies with bundler, then pull in the
submodules for `foreman` and the `heroku` CLI client repositories:

    $ bundle install --path vendor/bundle
    $ git submodule update --init --recursive

The packaging tasks vary by platform:

    $ bundle exec rake deb:build # build the apt-get repository
    $ bundle exec rake pkg:build # build an OS X .pkg file
    $ bundle exec rake exe:build # build an .exe file for Windows

Each one has a corresponding `*:release` task which also pushes the
artifacts up to S3. This requires the `HEROKU_RELEASE_ACCESS` and
`HEROKU_RELEASE_SECRET` environment variables to be set to the proper
AWS credentials.

# License

The MIT License (MIT)

Copyright © Heroku 2008 - 2012

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
