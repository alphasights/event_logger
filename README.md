# EventLogger

![CircleCI Build Status](https://circleci.com/gh/alphasights/event_logger.svg?style=shield&circle-token=:circle-token)

A really tiny event logger for sending events to elastic search

## Installation

Add this line to your application's Gemfile:

```ruby
gem "event_logger", git: "git@github.com:alphasights/event_logger.git"
```

And then execute:

$ bundle install

## Usage

To setup a logger:
```ruby
logger = EventLogger::Logger.new(
  application: "brazil",
  environment: "development",
  host: "https://elasticsearch.dev:9200",
)
```

To send an event:
```ruby
logger.event!(interaction_id: 12345,
              type: :analyst_picked_up,
              timestamp: Time.new(2012, 1, 2, 3, 4, 5, "-06:00"),
              twilio_code: "12345",
              attempts: 2,
              advisor: { name: "John Bohn",  email: "jjbohn@gmail.com", phone: "555-521-6937" },
              client: { name: "A Client", email: "client@example.com", phone: "555-344-1790" },
              analyst: { name: "Sandy Reid", email: "the.sandy@alphasights.com", phone: "555-813-8113" })
```

Dates and times will automatically be transformed to iso8601 strings
(the original hash you pass in won't be mutated though).


## Contributing

1. Fork it ( https://github.com/[my-github-username]/event_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
