<p class="download">
    <code><span>wget -qO- <a href="/install.sh">https://toolbelt.heroku.com/install.sh</a> | sh</span></code>
</p>

### What is it?

* [Heroku client](http://github.com/heroku/heroku) - CLI tool for creating and managing Heroku apps
* [Foreman](http://github.com/ddollar/foreman) - an easy option for running your apps locally
* [Git](http://code.google.com/p/git-osx-installer) - revision control and pushing to Heroku

### Other Distros

We hope to support other package managers in the future. In the mean time, you can use [RubyGems](http://rubygems.org) to install the Heroku client and Foreman:

    $ gem install heroku foreman

### Getting started

Once installed, you'll have access to the heroku command from your command shell. Log in using the email address and password you used when creating your Heroku account:

    $ heroku login
    Enter your Heroku credentials.
    Email: adam@example.com
    Password:
    Could not find an existing public key.
    Would you like to generate one? [Yn]
    Generating new SSH public key.
    Uploading ssh public key /Users/adam/.ssh/id_rsa.pub

You're now ready to create your first Heroku app:

    $ cd ~/myapp
    $ heroku create
    Creating stark-fog-398... done, stack is cedar
    http://stark-fog-398.herokuapp.com/ | git@heroku.com:stark-fog-398.git
    Git remote heroku added

### Technical details

The `heroku` command line client will be installed into `/usr/local/heroku` and the executable will be symlinked as `/usr/bin/heroku`.
