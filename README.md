# VibeIf

A Ruby gem that uses OpenAI to evaluate your instance variables and conditionally execute code blocks based on natural language descriptions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vibe-if'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install vibe-if
```

## Setup

Create an initializer (e.g., `config/initializers/vibe_if.rb` for Rails) or configure at the top of your script:

```ruby
require 'vibe_if'

VibeIf.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY'] # or your API key
  config.model = 'gpt-3.5-turbo' # optional, defaults to gpt-3.5-turbo
end
```

## Usage

Use the `vibe_if` method on any object to conditionally execute code based on natural language conditions:

```ruby
class User
  def initialize(name, age, status)
    @name = name
    @age = age
    @status = status
  end

  def check_eligibility
    vibe_if "user is an adult and active" do
      puts "#{@name} is eligible!"
    end

    vibe_if "user seems unhappy or inactive" do
      puts "Reaching out to #{@name}..."
    end
  end
end

user = User.new("Alice", 25, "active")
user.check_eligibility
```

The gem will send your instance variables to OpenAI, which evaluates the condition and returns true/false to determine whether the block should execute.

## Environment Variables

Set your OpenAI API key:
```bash
export OPENAI_API_KEY="your-openai-api-key-here"
```

## Inspiration

This gem was inspired by [vibesort](https://github.com/abyesilyurt/vibesort), a Python library that uses GPT for AI-powered array sorting.

## License

The gem is available as open source under the [MIT License](LICENSE).
