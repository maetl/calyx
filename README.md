# Calyx

[![Gem Version](http://img.shields.io/gem/v/calyx.svg)](https://rubygems.org/gems/calyx)
[![Build Status](https://img.shields.io/travis/maetl/calyx.svg)](https://travis-ci.org/maetl/calyx)

Calyx provides a simple API for generating text with declarative recursive grammars.

## Install

### Command Line

```
gem install calyx
```

### Gemfile

```
gem 'calyx'
```

## Examples

The best way to get started quickly is to install the gem and run the examples locally.

## Any Gradient

Requires Roda and Rack to be available.

```
gem install roda
```

Demonstrates how to use Calyx to construct SVG graphics. **Any Gradient** generates a rectangle with a linear gradient of random colours.

Run as a web server and preview the output in a browser (`http://localhost:9292`):

```
ruby examples/any_gradient.rb
```

Or generate SVG files via a command line pipe:

```
ruby examples/any_gradient > gradient1.xml
```

## Tiny Woodland Bot

Requires the Twitter client gem and API access configured for a specific Twitter handle.

```
gem install twitter
```

Demonstrates how to use Calyx to make a minimal Twitter bot that periodically posts unique tweets. See [@tiny_woodland on Twitter](https://twitter.com/tiny_woodland) and the [writeup here](http://maetl.net/notes/storyboard/tiny-woodlands).

```
TWITTER_CONSUMER_KEY=XXX-XXX
TWITTER_CONSUMER_SECRET=XXX-XXX
TWITTER_ACCESS_TOKEN=XXX-XXX
TWITTER_CONSUMER_SECRET=XXX-XXX
ruby examples/tiny_woodland_bot.rb
```

## Faker

[Faker](https://github.com/stympy/faker) is a popular library for generating fake names and associated sample data like internet addresses, company names and locations.

This example demonstrates how to use Calyx to reproduce the same functionality using custom lists defined in a YAML configuration file.

```
ruby examples/faker.rb
```

## Usage

Require the library and inherit from `Calyx::Grammar` to construct a set of rules to generate a text.

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

Obviously, this hardcoded sentence isn’t very interesting by itself. Possible variations can be added to the text by adding additional rules which provide a named set of text strings. The rule delimiter syntax (`{}`) can be used to substitute the generated content of other rules.

```ruby
class HelloWorld < Calyx::Grammar
  start '{greeting} world.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
end
```

Each time `#generate` runs, it evaluates the tree and randomly selects variations of rules to construct a resulting string.

```ruby
hello = HelloWorld.new

hello.generate
# > "Hi world."

hello.generate
# > "Hello world."

hello.generate
# > "Yo world."
```

By convention, the `start` rule specifies the default starting point for generating the final text. You can start from any other named rule by passing it explicitly to the generate method.

```ruby
class HelloWorld < Calyx::Grammar
  hello 'Hello world.'
end

hello = HelloWorld.new
hello.generate(:hello)
```

### Block Constructors

As an alternative to subclassing, you can also construct rules unique to an instance by passing a block when initializing the class:

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} world.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
end

hello.generate
```

### External File Formats

In addition to defining grammars in pure Ruby, you can load them from external JSON and YAML files:

```ruby
hello = Calyx::Grammar.load('hello.yml')
hello.generate
```

The format requires a flat map with keys representing the left-hand side named symbols and the values representing the right hand side substitution rules.

In JSON:

```json
{
  "start": "{greeting} world.",
  "greeting": ["Hello", "Hi", "Hey", "Yo"]
}
```

In YAML:

```yaml
---
start: "{greeting} world."
greeting:
  - Hello
  - Hi
  - Hey
  - Yo
```

### Nesting and Substitution

Rules are recursive. They can be arbitrarily nested and connected to generate larger and more complex texts.

```ruby
class HelloWorld < Calyx::Grammar
  start '{greeting} {world_phrase}.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
  world_phrase '{happy_adj} world', '{sad_adj} world', 'world'
  happy_adj 'wonderful', 'amazing', 'bright', 'beautiful'
  sad_adj 'cruel', 'miserable'
end
```

Nesting and hierarchy can be manipulated to balance consistency with novelty. The exact same word atoms can be combined in a variety of ways to produce strikingly different resulting texts.

```ruby
module HelloWorld
  class Sentiment < Calyx::Grammar
    start '{happy_phrase}', '{sad_phrase}'
    happy_phrase '{happy_greeting} {happy_adj} world.'
    happy_greeting 'Hello', 'Hi', 'Hey', 'Yo'
    happy_adj 'wonderful', 'amazing', 'bright', 'beautiful'
    sad_phrase '{sad_greeting} {sad_adj} world.'
    sad_greeting 'Goodbye', 'So long', 'Farewell'
    sad_adj 'cruel', 'miserable'
  end

  class Mixed < Calyx::Grammar
    start '{greeting} {adj} world.'
    greeting 'Hello', 'Hi', 'Hey', 'Yo', 'Goodbye', 'So long', 'Farewell'
    adj 'wonderful', 'amazing', 'bright', 'beautiful', 'cruel', 'miserable'
  end
end
```

### Random Sampling

By default, the outcomes of generated rules are selected with Ruby’s built-in pseudorandom number generator (as seen in methods like `Kernel.rand` and `Array.sample`). To seed the random number generator, pass in an integer seed value as the first argument to the constructor:

```ruby
MyGrammar.new(12345)
Calyx::Grammar.new(12345, &rules)
```

When a seed value isn’t supplied, `Time.new.to_i` is used as the default seed, which makes each run of the generator relatively unique.

### Weighted Selection

If you want to supply a weighted probability list, you can pass in arrays to the rule constructor, with the first argument being the template text string and the second argument being a float representing the probability between `0` and `1` of this choice being selected.

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

Or reproduce Gary Gygax’s famous generation table from the original [Dungeon Master’s Guide](https://en.wikipedia.org/wiki/Dungeon_Master%27s_Guide#Advanced_Dungeons_.26_Dragons) (page 171):

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

  empty 'Empty'
  monster 'Monster Only'
  monster_treasure 'Monster and Treasure'
  special 'Special'
  trick_trap 'Trick/Trap.'
  treasure 'Treasure'
end
```

### Template Expressions

Basic rule substitution uses single curly brackets as delimiters for template expressions:

```ruby
class Fruit < Calyx::Grammar
  start '{colour} {fruit}'
  colour 'red', 'green', 'yellow'
  fruit 'apple', 'pear', 'tomato'
end
```

## String Modifiers

Dot-notation is supported in template expressions, allowing you to call any available method on the `String` object returned from a rule. Formatting methods can be chained arbitrarily and will execute in the same way as they would in native Ruby code.

```ruby
class Greeting < Calyx::Grammar
  start '{hello.capitalize} there.', 'Why, {hello} there.'
  hello 'hello', 'hi'
end

# => "Hello there."
# => "Hi there."
# => "Why, hello there."
# => "Why, hi there."
```

You can also extend the grammar with custom modifiers that provide useful formatting functions.

### Filters

Filters accept an input string and return the transformed output:

```ruby
class Greeting < Calyx::Grammar
  filter :shoutycaps do |input|
    input.upcase
  end

  start '{hello.shoutycaps} there.', 'Why, {hello} there.'
  hello 'hello', 'hi'
end

# => "HELLO there."
# => "HI there."
# => "Why, HELLO there."
# => "Why, HI there."
```

### Mappings

The mapping shortcut allows you to specify a map of regex patterns pointing to their resulting substitution strings:

```ruby
class GreenBottle < Calyx::Grammar
  mapping :pluralize, /(.+)/ => '\\1s'
  start 'One green {bottle}.', 'Two green {bottle.pluralize}.'
  bottle 'bottle'
end

# => "One green bottle."
# => "Two green bottles."
```

### Modifier Mixins

In order to use more intricate rewriting and formatting methods in a modifier chain, you can add methods to a module and embed it in a grammar using the `modifier` classmethod.

Modifier methods accept a single argument representing the input string from the previous step in the expression chain and must return a string, representing the modified output.

```ruby
module FullStop
  def full_stop(input)
    input << '.'
  end
end

class Hello < Calyx::Grammar
  modifier FullStop
  start '{hello.capitalize.full_stop}'
  hello 'hello'
end

# => "Hello."
```

To share custom modifiers across multiple grammars, you can include the module in `Calyx::Modifiers`. This will make the methods available to all subsequent instances:

```ruby
module FullStop
  def full_stop(input)
    input << '.'
  end
end

class Calyx::Modifiers
  include FullStop
end
```

### Monkeypatching String

Alternatively, you can combine methods from existing Gems that monkeypatch `String`:

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
  fruit 'apple', 'orange', 'banana', 'pear'
end

# => "An apple."
# => "An orange."
# => "A banana."
# => "A pear."
```

### Memoized Rules

Rule expansions can be ‘memoized’ so that multiple references to the same rule return the same value. This is useful for picking a noun from a list and reusing it in multiple places within a text.

The `@` sigil is used to mark memoized rules. This evaluates the rule and stores it in memory the first time it’s referenced. All subsequent references to the memoized rule use the same stored value.

```ruby
# Without memoization
grammar = Calyx::Grammar.new do
  start '{name} <{name.downcase}>'
  name 'Daenerys', 'Tyrion', 'Jon'
end

3.times { grammar.generate }
# => Daenerys <jon>
# => Tyrion <daenerys>
# => Jon <tyrion>

# With memoization
grammar = Calyx::Grammar.new do
  start '{@name} <{@name.downcase}>'
  name 'Daenerys', 'Tyrion', 'Jon'
end

3.times { grammar.generate }
# => Tyrion <tyrion>
# => Daenerys <daenerys>
# => Jon <jon>
```

Note that the memoization symbol can only be used on the right hand side of a production rule.

### Unique Rules

Rule expansions can be marked as ‘unique’, meaning that multiple references to the same rule always return a different value. This is useful for situations where the same result appearing twice would appear awkward and messy.

Unique rules are marked by the `$` sigil.

```ruby
grammar = Calyx::Grammar.new do
  start "{$medal}, {$medal}, {$medal}"
  medal 'Gold', 'Silver', 'Bronze'
end

grammar.generate
# => Silver, Bronze, Gold
```

**Note: this is a new and experimental feature and the API may change as kinks are ironed out from testing and exploration.**

### Dynamically Constructing Rules

Template expansions can be dynamically constructed at runtime by passing a context map of rules to the `#generate` method:

```ruby
class AppGreeting < Calyx::Grammar
  start 'Hi {username}!', 'Welcome back {username}...', 'Hola {username}'
end

context = {
  username: UserModel.username
}

greeting = AppGreeting.new
greeting.generate(context)
```

### Accessing the Raw Generated Tree

Calling `#evaluate` on the grammar instance will give you access to the raw generated tree structure before it gets flattened into a string.

The tree is encoded as an array of nested arrays, with the leading symbols labeling the choices and rules selected, and the trailing terminal leaves encoding string values.

This may not make a lot of sense unless you’re familiar with the concept of [s-expressions](https://en.wikipedia.org/wiki/S-expression). It’s a fairly speculative feature at this stage, but it leads to some interesting possibilities.

```ruby
grammar = Calyx::Grammar.new do
  start 'Riddle me ree.'
end

grammar.evaluate
# => [:start, [:choice, [:concat, [[:atom, "Riddle me ree."]]]]]
```

## Roadmap

Rough plan for stabilising the API and features for a `1.0` release.

| Version | Features planned |
|---------|------------------|
| `0.6`   | ~~block constructor~~ |
| `0.7`   | ~~support for template context map passed to generate~~ |
| `0.8`   | ~~method missing metaclass API~~ |
| `0.9`   | ~~return grammar tree from `#evaluate`, with flattened string from `#generate` being separate~~ |
| `0.10`  | ~~inject custom string functions for parameterised rules, transforms and mappings~~ |
| `0.11`  | ~~support YAML format (and JSON?)~~ |
| `0.12`   | ~~API documentation~~ |
| `0.13`   | ~~Support for unique rules~~ |
| `0.14`   | Options config and ‘strict mode’ error handling |
| `0.15`   | Improve representation of weighted probability selection |

## Credits

### Author & Maintainer

- [Mark Rickerby](https://github.com/maetl)

### Contributors

- [Tariq Ali](https://github.com/tra38)

## License

Calyx is open source and provided under the terms of the MIT license. Copyright (c) 2015-2017 [Editorial Technology](http://editorial.technology/).

See the `LICENSE` file [included with the project distribution](https://github.com/maetl/calyx/blob/master/LICENSE) for more information.
