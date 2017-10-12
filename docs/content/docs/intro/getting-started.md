---
title: Getting Started
layout: docs
permalink: /docs/intro/getting-started/
---

## Hello World

Require the Calyx library and use `Calyx::Grammar` to define the rules for your generated text.

```ruby
require "calyx"

hello = Calyx::Grammar.new do
  start "Hello world."
end
```

To generate a text result, call the `#generate` method on the grammar object.

```ruby
puts hello.generate
# => Hello world.
```

## Adding choices

Obviously, this hardcoded sentence isn’t very interesting by itself. To add variety to the text, rules can be defined with multiple choices.

```ruby
hello = Calyx::Grammar.new do
  start 'Hello world.', 'Hi world.', 'Hey world.'
end
```

Each time `#generate` runs, Calyx evaluates the grammar and randomly selects a single choice from the list of possible choices.

```ruby
hello.generate
# => Hi world.

hello.generate
# => Hello world.

hello.generate
# => Yo world.
```

## Expanding rules inside other rules

Recursively nesting rules inside other rules is the core idea of generative grammars. Calyx makes this possible with a template expansion syntax.

When you wrap the name of a rule in curly brackets, Calyx will expand the embedded rule and replace it with generated output each time the grammar runs.

The following example expands the `greeting` rule within the `start` rule.

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} world.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
end
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
