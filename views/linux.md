<p class="download">
    <code>wget -qO- <a href="https://toolbelt.heroku.com/install.sh">https://toolbelt.heroku.com/install.sh</a> | sh</code>
</p>

### What is it?

The Heroku Toolbelt for Debian/Ubuntu will give you everything you need to get started using Heroku. The installer contains:

* [Heroku client](http://github.com/heroku/heroku) - CLI tool for creating and managing Heroku apps
* [Foreman](http://github.com/ddollar/foreman) - an easy option for running your apps locally
* [Git](http://code.google.com/p/git-osx-installer) - revision control and pushing to Heroku

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
    $ heroku create --stack cedar
    Creating stark-fog-398... done, stack is cedar
    http://stark-fog-398.herokuapp.com/ | git@heroku.com:stark-fog-398.git
    Git remote heroku added

### Staying up to date

To keep your heroku client updated, simply run `heroku update`

    $ heroku update
    -----> Updating to latest client... done

### Technical details

The `heroku` command line client will be installed into `/usr/local/heroku` and the executable will be symlinked as `/usr/bin/heroku`.
