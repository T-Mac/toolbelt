<p class="button">
  <a href="/windows/download">Heroku Toolbelt for Windows</a>
</p>

### What is it?

The Heroku Toolbelt for Windows will give you everything you need to get started using Heroku. The installer contains:

* A standalone version of the [heroku](http://github.com/heroku/heroku)
* [msysgit which includes both git and ssh](http://code.google.com/p/msysgit)

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

The `heroku` client will be installed into Program Files, and will contain a bundled Ruby VM for its own execution.
