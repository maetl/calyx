# Calyx

Calyx provides a simple API for generating text with declarative recursive grammars.

## Install

### Command Line

```
gem install tra38-calyx
```

## Gemfile

```
gem 'tra38-calyx'
```

## Usage
To construct rules for generating text, you must first require "calyx", and then inherit from either the `Calyx::Grammar` class or the `Calyx::DataTemplate` class.

Classes that inherit from `Calyx::Grammar` are used to construct a set of rules that can generate a text. All grammars require a `start` rule, which specifies the starting point for generating the text structure.

Classes that inherit from `Calyx::DataTemplate` are used to construct a set of "meta-rules" that will invoke Grammar rules for you. All templates require a `write_narrative` method which specifies what "meta-rules" are being called.

```ruby
require 'calyx'

class HelloWorld < Calyx::Grammar
 start "Hello World."
end

class Greeting < Calyx::DataTemplate
 def write_narrative
  write HelloWorld
 end
end
```

There are two ways to generate text. You can generate text using Calyx::Grammar by initializing the object and calling the `generate` method.

```ruby
hello = HelloWorld.new
hello.generate
# > "Hello World."
```

Or, you can generate text by initializing the Calyx::DataTemplate class and calling the `result` method.
```ruby
greeting = Greeting.new
greeting.result
# > "Hello World."
```

### Calyx::Grammar
Obviously, "Hello World" isn’t very interesting by itself. Possible variations can be added to the text using the `rule` constructor to provide a named set of text strings and the rule delimiter syntax (`{}`) within the text strings to substitute the generated content of the rule.

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
    ['3', 0.556],
    ['4', 0.833],
    ['5', 0.1111],
    ['6', 0.1389],
    ['7', 0.1667],
    ['8', 0.1389],
    ['9', 0.1111],
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
  rule :special, 'Special'
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

In order to use more intricate natural language processing capabilities, you can embed additional methods onto the `String` class yourself, as well as use methods from existing Gems that monkeypatch `String`.

```ruby
require 'indefinite_article'

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

### Calyx::DataTemplate
Calyx::DataTemplate is useful for allowing a computer to write stories based on data stored within a Hash. The data can be plugged instantly into generated content, so long as you use erb syntax (to distingush from the rule delimiter syntax).

```ruby
require 'date'

class StockReport < Calyx::Grammar
 start "The price of one share of <%= name %> on <%= date %> is <%= price %> Yen."
end

class StockWriter < Calyx::DataTemplate
 def write_narrative
  write StockReport
 end
end

cyberdyne = { :name => "Cyberdyne", :price => 1897.0, :date => Date.new(2015,1,14) }

stock_writer = StockWriter.new(cyberdyne)
stock_writer.result
# => "The price of one share of Cyberdyne on 2015-01-14 is 1897.0 Yen."
```

`conditional_write` allows Calyx::DataTemplate to choose what grammar rule to invoke. If the condition is true, use the first grammar; otherwise, use the second grammar.
```ruby
class GoodStock < Calyx::Grammar
 start "You should buy stock in <%= name %> because this company has a low EPS."
end

class BadStock < Calyx::Grammar
 start "You should sell stock in <%= name %> because this company has a high EPS."
end

class StockWriter < Calyx::DataTemplate
 def write_narrative
  conditional_write eps <= 20, GoodStock, BadStock
 end
end

mitsui = { :name => "Mitsui", :eps => 15.8}
mitsui_writer = StockWriter.new(mitsui)
mitsui_writer.result
# => "You should buy stock in Mitsui because this company has a low EPS."

tokoyo_electric = { :name => "Tokyo Electric Power", :eps => 275.2 }
tokoyo_electric_writer = StockWriter.new(tokoyo_electric)
tokoyo_electric_writer.result
# => "You should sell stock in Tokoyo Electric Power because this company has a high EPS."
```

You may also only provide only one grammar for `conditional_write`. If the condition is false, then nothing will be written.
```ruby
class StockWriter < Calyx::DataTemplate
 def write_narrative
  conditional_write eps <= 20, GoodStock
 end
end

tokoyo_electric = { :name => "Tokyo Electric Power", :eps => 275.2 }
tokoyo_electric_writer = StockWriter.new(tokoyo_electric)
tokoyo_electric_writer.result
# => ""
```

By simply specifying a few "meta-rules" with conditionals and Grammars, you can generate unique, readable narratives based on your data.
```ruby
class StockWriter < Calyx::DataTemplate
 def write_narrative
   write StockReport
   conditional_write eps <= 20, GoodStock, BadStock
   conditional_write eps <= 10, WonderfulStock
   conditional_write eps >= 50, AbsolutelyHorribleStock
   write ThanksForReading
  end
end
```

###

## License

Calyx is open source and provided under the terms of the MIT license. Copyright (c) 2015 Mark Rickerby, (c) 2016 Tariq Ali

See the `LICENSE` file [included with the project distribution](https://github.com/tra38/calyx/blob/master/LICENSE) for more information.

## History
In November 2015, Mark Rickerby created Calyx and used that gem to create [choose-your-own adventure gamebooks](https://github.com/dariusk/NaNoGenMo-2015/issues/189). He later on wrote a [blog post](http://maetl.net/notes/storyboard/gamebook-of-dungeon-tropes) explaining his thought process.

In January 2016, Tariq Ali forked Calyx and started adding in new features to turn Calyx into a useful tool for generating data-driven narratives (robojournalism).

## Disclaimer
In the real world, you would probably not want to buy or sell Japanese stock based solely on EPS. [The MIT Encyclopedia of the Japanese Economy](https://books.google.com/books?id=0RS0CGUaef8C&pg=PA423&lpg=PA423&dq=high+earnings+per+share+in+japan&source=bl&ots=sR8KV0fBTk&sig=qHspeX72SmpsU25wz9AZnhaAxyU&hl=en&sa=X&ved=0ahUKEwjcnqqctrLKAhWKRiYKHdKACaoQ6AEIHDAA#v=onepage&q=high%20earnings%20per%20share%20in%20japan&f=false) can provide some reasons why.