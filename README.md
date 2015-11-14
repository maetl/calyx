# Calyx

Calyx provides a simple API for generating text with declarative recursive grammars.

## Install

### Command Line

```
gem install calyx
```

## Gemfile

```
gem 'calyx'
```

## Usage

Require the library and inherit from `Calyx::Grammar` to construct a set of rules to generate a text. All grammars require a `start` rule, which specifies the starting point for generating the text structure.

```ruby
require 'calyx'

class HelloWorld < Calyx::Grammar
  start 'Hello world.'
end
```

To generate the text itself, initialize the object and call the `generate` method.

```ruby
hello = HelloWorld.new
hello.generate
# > "Hello world."
```

Obviously, this hardcoded sentence isn’t very interesting by itself. Possible variations can be added to the text using the `rule` constructor to provide a named set of text strings and the rule delimiter syntax (`{}`) within the text strings to substitute the generated content of the rule.

```ruby
class HelloWorld < Calyx::Grammar
  start '{greeting} world.'
  rule :greeting, 'Hello', 'Hi', 'Hey', 'Yo'
end

hello = HelloWorld.new

hello.generate
# > "Hi world."

hello.generate
# > "Hello world."

hello.generate
# > "Yo world."
```

Rules are recursive. They can be arbitrarily nested and connected to generate larger and more complex texts.

```ruby
class HelloWorld < Calyx::Grammar
  start '{greeting} {world_phrase}.'
  rule :greeting, 'Hello', 'Hi', 'Hey', 'Yo'
  rule :world_phrase, '{happy_adj} world', '{sad_adj} world', 'world'
  rule :happy_adj, 'wonderful', 'amazing', 'bright', 'beautiful'
  rule :sad_adj, 'cruel', 'miserable'
end
```

Nesting and hierarchy can be used in different ways to balance consistency with variation. The exact same word atoms can be combined in different ways to produce strikingly different resulting texts.

```ruby
module HelloWorld
  Sentiment < Calyx::Grammar
    start '{happy_phrase}', '{sad_phrase}'
    rule :happy_phrase, '{happy_greeting} {happy_adj} world.'
    rule :happy_greeting, 'Hello', 'Hi', 'Hey', 'Yo'
    rule :happy_adj, 'wonderful', 'amazing', 'bright', 'beautiful'
    rule :sad_phrase, '{sad_greeting} {sad_adj} world.'
    rule :sad_greeting, 'Goodbye', 'So long', 'Farewell'
    rule :sad_adj, 'cruel', 'miserable'
  end

  Mixed < Calyx::Grammar
    start '{greeting} {adj} world.'
    rule :greeting, 'Hello', 'Hi', 'Hey', 'Yo', 'Goodbye', 'So long', 'Farewell'
    rule :adj, 'wonderful', 'amazing', 'bright', 'beautiful', 'cruel', 'miserable'
  end
end
```

## License

Calyx is open source and provided under the terms of the MIT license. Copyright (c) 2015 Mark Rickerby

See the `LICENSE` file [included with the project distribution](https://github.com/maetl/calyx/blob/master/LICENSE) for more information.
