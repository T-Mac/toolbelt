### Heroku Toolbelt for Debian/Ubuntu

### What is it?

The Heroku Toolbelt for Debian/Ubuntu will give you everything you need to get started using Heroku. The installer contains:

* A standalone version of the [heroku command lineclient](http://github.com/heroku/heroku)
* [Foreman](http://github.com/ddollar/foreman) for running your apps locally
* [Git](http://git-scm.com/) for revision control and pushing to Heroku

### Installation

    $ sudo -s  # become root
    $ echo "deb http://toolbelt.herokuapp.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list
    $ wget -q -O - http://toolbelt.herokuapp.com/apt/release.key | apt-key add -
    $ apt-get update
    $ apt-get install heroku-toolbelt

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
    Creating stark-sword-398... done, stack is cedar
    http://stark-sword-398.herokuapp.com/ | git@heroku.com:stark-sword-398.git
    Git remote heroku added

### Staying up to date

To keep your heroku client updated, simply run `heroku update`

    $ heroku update
    -----> Updating to latest client... done

### Technical details

The `heroku` client will be installed into Program Files, and will contain a bundled Ruby VM for its own execution.
