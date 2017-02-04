# ProjectStore

`project_store` is a simple gem to persist a collection of Ruby objects in a Yaml based backing store.  
 As opposed to standard Yaml persistence mechanisms, the dump/reload mechanism is based on the `type` (as
 in the `type` property) of objects.
 
 All objects are actually pure hashes "decorated" by some modules depending on their `type` property.
  
 By default any object loaded from a store will have the `ProjectStore::Entity::Base` module "applied" (the hash read 
 from the yaml backend will extend that module).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'project_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install project_store

## Usage

The only real two objects you have to use are:

* `ProjectStore::Base` which represents a yaml datastore
* `ProjectStore::Entity::Base` which represents a basic object loaded from yaml

## Development

After checking out the repo, run `bin/setup` to install dependencies. 
Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will 
allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version,
update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a
git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lbriais/project_store. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


