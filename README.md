
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable', :git => 'https://github.com/mabenson000/todoable.git'
```

And then execute:

    $ bundle

## Usage

Open your console and run

```
  $ ruby bin/console.rb
```

Start a client with username and password

```ruby
  client = Todoable::Client.new(username: username, password: password)
```

Use the commands below to interact with the todable server

  ```ruby
    client.create_list(name: name)

    client.delete_list(list_id: list_id)

    client.get_lists

    client.add_list_item(list_id: list_id, name: name)

    client.finish_item(list_id: list_id, item_id: item_id)
  ```





## Development

Note: Ignore Rakefile/gemspec etc because...

I wanted to do specs for this, because 1. you should do specs and 2. its a pain to test without them, but I couldn't get the set-up to work on my PC. Kept getting `uninitialized constant RSpec::Expectations::MultipleExpectationsNotMetError` which is a fun sounding one.
