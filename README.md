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

Nesting and hierarchy can be manipulated to balance consistency with variation. The exact same word atoms can be combined in different ways to produce strikingly different resulting texts.

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

By default, the outcomes of generated rules are selected with Ruby’s built-in random number generator (as seen in methods like `Kernel.rand` and `Array.sample`). If you want to supply a weighted probability list, you can pass in arrays to the rule constructor, with the first argument being the template text string and the second argument being a float representing the probability between `0` and `1` of this choice being selected.

For example, you can model the triangular distribution produced by rolling 2d6:

```ruby
class Roll2D6 < Calyx::Grammar
  start(
    ['2', 0.0278],
    ['3',	0.556],
    ['4',	0.833],
    ['5',	0.1111],
    ['6',	0.1389],
    ['7',	0.1667],
    ['8',	0.1389],
    ['9',	0.1111],
    ['10', 0.833],
    ['11', 0.556],
    ['12', 0.278]
  )
end
```

Or reproduce Gary Gygax’s famous generation table from the original Dungeon Master’s Guide (page 171):

```ruby
class ChamberOrRoomContents < Calyx::Grammar
  start(
    [:empty, 0.6],
    [:monster, 0.1],
    [:monster_treasure, 0.15],
    [:special, 0.05],
    [:trick_trap, 0.05],
    [:treasure, 0.05]
  )

  rule :empty, 'Empty'
  rule :monster, 'Monster Only'
  rule :monster_treasure, 'Monster and Treasure'
  rule :monster_treasure, 'Special'
  rule :trick_trap, 'Trick/Trap.'
  rule :treasure, 'Treasure'
end
```

Dot-notation is supported in template expressions, allowing you to call any available method on the `String` object returned from a rule. Formatting methods can be chained arbitrarily and will execute in the same way as they would in native Ruby code.

```ruby
class Greeting < Calyx::Grammar
  start '{hello.capitalize} there.', 'Why, {hello} there.'
  rule :hello, 'hello'
end

# => "Hello there."
# => "Why, hello there."
```

In order to use more intricate natural language processing capabilities, you can embed additional methods onto the `String` class yourself, or use methods from existing Gems that monkeypatch `String`.

```ruby
include 'indefinite_article'

module FullStop
  def full_stop
    self << '.'
  end
end

class String
  include FullStop
end

class NounsWithArticles < Calyx::Grammar
  start '{fruit.with_indefinite_article.capitalize.full_stop}'
  rule :fruit, 'apple', 'orange', 'banana', 'pear'
end

# => "An apple."
# => "An orange."
# => "A banana."
# => "A pear."
```

## License

Calyx is open source and provided under the terms of the MIT license. Copyright (c) 2015 Mark Rickerby

See the `LICENSE` file [included with the project distribution](https://github.com/maetl/calyx/blob/master/LICENSE) for more information.
