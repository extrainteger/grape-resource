# GrapeResource

GrapeResource is opinionated resource generator for your Grape API mounted inside Rails. 

By using GrapeResource, you could generate Grape endpoints just like rails generate scaffold controller. GrapeResource only generates API resource. You need to create a model by yourself.

## Dependencies

1. Grape (mounted on Rails)
2. Grape Entity
3. Rspec

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape_resource'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape_resource

## Usage

### Initialize

Initialize GrapeResource with command :

    $ rails g grape_resource:install

### Configuration

Modify GrapeResource configuration inside `config/initializers/grape_resource.rb`

1. `config.directory` will be your endpoint directory. Default to : `controllers/API/v1/`
2. `config.class_name_prefix` will be your class name prefix for your endpoint. Default to : `API::V1`

### Generator

To generate REST API :

    $ rails g grape_resource:rest class_name

This will give you :

1. GET /
2. GET /:id
3. POST /
4. PUT /:id
5. DELETE /:id

To generate namespaced API :  
    
    $ rails g grape_resource:namespace namespace api_endpoint1 api_endpoint2:method 

While method is one of :

1. `get` (default)
2. `post`
3. `put`
4. `delete`

Command above will give you :

1. GET /namespace/api_endpoint1
2. METHOD /namespace/api_endpoint2

Endpoint generators above contains :

1. `routes.rb` This is your endpoint entry point. You could mount it to your main entry point
2. `entities` directory. It contains grape entity for your endpoint.
3. `resources` directory. It contains your endpoint.
4. `spec` directory. It contains rspec test for your endpoint.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Release

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

You could use [gem release](https://github.com/svenfuchs/gem-release). 
1. Install gem release using command `gem install gem-release`. 
2. Update version using command `gem bump minor`
3. Build gem using command `gem build grape-resource.gemspec`
4. Release gem using command `gem release`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/extrainteger/grape_resource. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GrapeResource project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/extrainteger/grape_resource/blob/master/CODE_OF_CONDUCT.md).
