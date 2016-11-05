The KnuVerse Knufactor SDK for Ruby
====================

About
----
This project is a Ruby SDK that allows developers to create apps that use Knuverse's Knufactor Cloud APIs.

Documentation for the API can be found [here](https://cloud.knuverse.com/docs/)

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

    require 'knuverse/knufactor'
    
    # configure the client singleton
    KnuVerse::Knufactor::Client.configure(apikey: 'b1b71d68cffea1d43257fff9deadbeef', secret: 'testtest4m', account: 12345678900)
    
    # pull some data
    KnuVerse::Knufactor::Client.about_service
    # => {"company"=>"KnuVerse", "version"=>"1.4.0", "multi_tenant"=>true, "service"=>"audiopin", "name"=>"KnuVerse"}
    
    # interact with the singleton as a client instance for simplicity
    client = KnuVerse::Knufactor::Client.instance
    
    # In complex, multi-user systems, using a singleton class might not work.
    # For this reason, there is a regular class version of the client that is not tied to the singleton
    local_client1 = KnuVerse::Knufactor::SimpleClient.new(
      apikey: 'b1b71d68cffea1d43257fff9deadbeef', secret: 'testtest4m', account: 12345678900
    )
    local_client2 = KnuVerse::Knufactor::SimpleClient.new(
      apikey: 'b1b71d68cffea1d43257fff9deadf00d', secret: 'testtest4m', account: 12345678900
    )
    local_client1 == local_client2
    # => false

License
-------
This project and all code contained within it are released under the [MIT License](https://opensource.org/licenses/MIT). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> All contributions to this project will be released under the [MIT License](https://opensource.org/licenses/MIT). By submitting a pull request, you are agreeing to comply with this license and for any contributions to be released under it.
