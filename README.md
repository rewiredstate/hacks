# Rewired State Hacks [![Build Status](https://travis-ci.org/rewiredstate/hacks.png?branch=master)](https://travis-ci.org/rewiredstate/hacks)

A database for all hacks created at Rewired State events.

## Configuration

Screenshot uploads in the production environment are using Amazon S3 at present, so you'll need to set your credentials and bucket in the environment:

    export S3_KEY=<key>
    export S3_SECRET=<secret>
    export S3_BUCKET=<bucket>

(on Heroku these can be set with `heroku config:add S3_KEY=<key>`)

You can create an admin user with the Rake task:

    $ bundle exec rake admin:create[example@example.com,abcdefhi]
    => Created admin user example@example.com

## Getting Started

The easiest way to run the application in development is with Unicorn.

    bundle install
    bundle exec rake db:setup
    bundle exec unicorn -p 4567

## Testing

We're using RSpec for model and controller testing. To run all the tests:

    bundle exec rake

## Colophon

* Award icons from [Farm-Fresh](http://www.fatcow.com/free-icons)

## Contributors

* [Jordan Hatch](http://jordanh.net/)
* [Adam McGreggor](http://blog.amyl.org.uk/)

## License

MIT License
