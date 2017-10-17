---
title: Tutorial
layout: docs
permalink: /introduction/tutorial
---

## Objective

This tutorial introduces Calyx with a basic ‘hello world’ example. Following these steps will help you get Calyx up and running and provide you with a code skeleton to start adding more interesting and creative things.

## Initial setup

Before getting started, you’ll need to install Calyx from RubyGems and have it available in your local dev environment.

```
gem install calyx
```

If you’re not sure how to do this yet, there’s more information about setting up your Ruby environment in the [resources for beginners](/introduction/beginners). The [installation guide](/docs/guide/installation) contains further details about prerequisites and how to download and install the Gem.

## Getting started

Create a file named `hello.rb` and add the following contents.

```ruby
require "calyx"

hello = Calyx::Grammar.new do
  start "Hello world!"
end
```

The first line imports the Calyx library and the lines following use the `Calyx::Grammar` class to define the rules for the generated text, in this case just ‘Hello world!’.

To generate the text result, call the `#generate` method on the grammar object. Add this to the bottom of the `hello.rb` file.

```ruby
puts hello.generate
```

Run it on the command line by typing `ruby hello.rb`. You should see the following result.

```
Hello world!
```

## Adding random choices

Obviously, this hardcoded sentence isn’t very interesting by itself. To add variety to the text, rules can be defined with multiple choices to pick from  .

```ruby
hello = Calyx::Grammar.new do
  start 'Hello world!', 'Hi world!', 'Hey world!'
end
```

Each time `#generate` runs, Calyx evaluates the grammar and randomly selects a single choice from the list of possible choices.

```ruby
hello.generate
# => Hi world!

hello.generate
# => Hello world!

hello.generate
# => Yo world!
```

## Nesting rules inside rules

Nesting rules inside other rules is the core idea of generative grammars. When you embed the name of a rule in curly brackets inside a text fragment, Calyx will expand the embedded rule and replace it with generated output each time the grammar runs.

The following example nests the `greeting` rule within the `start` rule.

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} world!'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
end
```

This generates the exact same text as before, but listing the greeting words on their own is more flexible and eliminates the need to write each variation of the phrase out in full.

This process of starting with a larger fragment of text and breaking it up into smaller phrases and single words is something you’ll do a lot when writing larger and more detailed grammars.

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
