---
title: Getting Started
layout: docs
permalink: /docs/intro/getting-started/
---

# Getting Started

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

## Block Constructors

As an alternative to subclassing, you can also construct rules unique to an instance by passing a block when initializing the class:

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} world.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
end

hello.generate
```

## Template Expressions

Basic rule substitution uses single curly brackets as delimiters for template expressions:

```ruby
fruit = Calyx::Grammar.new do
  start '{colour} {fruit}'
  colour 'red', 'green', 'yellow'
  fruit 'apple', 'pear', 'tomato'
end

6.times { fruit.generate }
# => "yellow pear"
# => "red apple"
# => "green tomato"
# => "red pear"
# => "yellow tomato"
# => "green apple"
```

## Nesting and Substitution

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
