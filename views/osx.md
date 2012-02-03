<p class="button">
	<a href="/osx/download">Heroku Toolbelt for OSX</a>
</p>

### What is it?

The Heroku Toolbelt for OSX will give you everything you need to get started using Heroku. The installer contains:

* A standalone version of the [heroku command line client](http://github.com/heroku/heroku)
* [git-osx-installer for Snow Leopard and below](http://code.google.com/p/git-osx-installer)

### Getting started

Once installed, you'll have access to the heroku command from your command shell. Log in using the email address and password you used when creating your Heroku account:

<pre><code><span class="highlight">$ heroku login</span>
Enter your Heroku credentials.
Email: adam@example.com
Password:
Could not find an existing public key.
Would you like to generate one? [Yn]
Generating new SSH public key.
Uploading ssh public key /Users/adam/.ssh/id_rsa.pub</code></pre>

You're now ready to create your first Heroku app:

<pre><code><span class="highlight">$ cd ~/myapp</span>
<span class="highlight">$ heroku create --stack cedar</span>
Creating stark-sword-398... done, stack is cedar
http://stark-sword-398.herokuapp.com/ | git@heroku.com:stark-sword-398.git
Git remote heroku added</code></pre>

### Staying up to date

To keep your heroku client updated, simply run `heroku update`

<pre><code><span class="highlight">$ heroku update</span>
-----> Updating to latest client... done</code></pre>

### Technical details

The `heroku` command line client will be installed into `/usr/local/heroku` and the executable will be symlinked as `/usr/bin/heroku`.
