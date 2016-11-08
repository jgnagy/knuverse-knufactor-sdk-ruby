The KnuVerse Knufactor SDK for Ruby
====================

About
----
This project is a Ruby SDK that allows developers to create apps that use Knuverse's Knufactor Cloud APIs.

Documentation for the API can be found [here](https://cloud.knuverse.com/docs/)
Full documentation for this SDK can be found [here](http://www.rubydoc.info/gems/knuverse-knufactor/)

Note that this SDK isn't a direct port of the [Python SDK](https://github.com/KnuVerse/knuverse-sdk-python), though it is based heavily on the work done there. This SDK uses a Object-Oriented pattern, which is likely more familiar to Ruby developers than a collection of functions may be.

Building and Installing
----
Building the gem requires a modern Ruby:

    # highly recommend using RVM here, and Ruby 2.x or above
    gem build knuverse-knufactor.gemspec
    # install what you just built
    gem install knuverse-knufactor-*.gem

That said, recent releases should be available on [rubygems.org](https://rubygems.org/) so building is probably not necessary.

Just add the following to your Gemfile:

    gem 'knuverse/knufactor'

Then run:

    bundle install

If you're not using [bundler](http://bundler.io/) for some reason (shame on you!), you can manually install like so:

    gem install knuverse-knufactor

If you see a message like this:

    Thanks for installing the KnuVerse Knufactor Ruby SDK!

You should be all set!

Usage
------
Check back, because this file will be updated with a lot more usage examples.

For a typical custom ruby application, you'll need to do something like the following to get started:

```ruby
require 'knuverse/knufactor'

# configure the API client singleton
KnuVerse::Knufactor::APIClient.configure(
  apikey: 'b1b71d68cffea1d43257fff9deadbeef',
  secret: '34d04e5f05a194444e9c26358a94eaf2'
)
```

From here, the SDK will automatically rely on this configuration singleton unless you tell it otherwise. Here are some examples of interacting with the API:

```ruby
# pull some data
KnuVerse::Knufactor::APIClient.about_service
# => {"company"=>"KnuVerse", "version"=>"1.4.0", "multi_tenant"=>true, "service"=>"audiopin", "name"=>"KnuVerse"}

# Make working with resources easier
include KnuVerse::Knufactor::Resources

# Find some clients
clients = Client.all

# Take a look at the last client
client = clients.last
client.name
# => "user75"

# Make a change
client.bypass_limit = 10

# Now persist it
client.save

# Verify the change worked
client.reload
client.bypass_limit
# => 10

# Find some specific clients... all locked out clients
locked_clients = Client.where(:password_lock?, true)
# => #<KnuVerse::Knufactor::ResourceCollection:...

# Find clients that are either enrolled or installed
happy_clients = Client.where(:state, 'enrolled').or(:state, 'installed')

# Find clients with a name that starts with "z"
z_clients = Client.where(:name, /^z/i)
```

For some more complex situations, you may want a specialized API Client (interact with it as an instance, or have a thread-local or context-specific client):

```ruby
# interact with the singleton as a client instance for simplicity
api_client = KnuVerse::Knufactor::APIClient.instance

# In complex, multi-user systems, using a singleton class might not work.
# For this reason, there is a regular class version of the API client that is not tied to the singleton
local_api_client1 = KnuVerse::Knufactor::SimpleAPIClient.new(
  apikey: 'b1b71d68cffea1d43257fff9deadbeef', secret: '57838344acf7f5876226ede247c5881a'
)
local_api_client2 = KnuVerse::Knufactor::SimpleAPIClient.new(
  apikey: '33371d68cffea1d43257fff9deadf00d', secret: 'e7d1c88825dc96a05bc38c39cca4a1ca'
)
local_api_client1 == local_api_client2
# => false

# Perform an operation with a specific instance of the API Client
Client.all(api_client: local_api_client1)
# All finder methods work this way, allowing the 'api_client' option to be passed
Client.where(:name, 'bobby', api_client: local_api_client2)

```

License
-------
This project and all code contained within it are released under the [MIT License](https://opensource.org/licenses/MIT). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> All contributions to this project will be released under the [MIT License](https://opensource.org/licenses/MIT). By submitting a pull request, you are agreeing to comply with this license and for any contributions to be released under it.
