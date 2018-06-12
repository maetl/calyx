---
title: Tutorial
layout: docs
permalink: /introduction/tutorial
---

## Objective

This tutorial introduces Calyx with a basic ‘hello world’ example. Following these steps will help you get Calyx up and running and provide you with a code skeleton to start adding more interesting and creative things.

## Initial setup

Before getting started, you’ll need to install Calyx from RubyGems and have it available in your local dev environment:

```
gem install calyx
```

If you’re not sure how to do this yet, there’s more information about setting up your Ruby environment in the [resources for beginners](/introduction/beginners/). The [installation guide](/docs/guide/installation/) contains further details about prerequisites and how to download and install the Gem.

## Getting started

Create a file named `hello.rb` and add the following contents:

```ruby
require "calyx"

hello = Calyx::Grammar.new do
  start "Hello world!"
end
```

The first line imports the Calyx library and the lines following use the `Calyx::Grammar` class to define the rules for the generated text, in this case just ‘Hello world!’.

To generate the text result, call the `#generate` method on the grammar object. Add this to the bottom of the `hello.rb` file:

```ruby
puts hello.generate
```

Run it on the command line by typing `ruby hello.rb`. You should see the following result:

```
Hello world!
```

## Adding random choices

Obviously, this hardcoded sentence isn’t very interesting by itself. To add variety to the text, rules can be defined with multiple choices to pick from:

```ruby
hello = Calyx::Grammar.new do
  start 'Hello world!', 'Hi world!', 'Hey world!'
end
```

Each time `#generate` runs, Calyx evaluates the grammar and randomly selects a single choice from the list of possible choices. So if we run the grammar three times, we might see three different results:

```ruby
hello.generate
# => Hi world!

hello.generate
# => Hello world!

hello.generate
# => Yo world!
```

## Nesting rules inside rules

When you embed the name of a rule in curly brackets inside a text fragment, Calyx will expand the embedded rule and replace it with generated output each time the grammar runs.

The following example nests the `greeting` rule within the `start` rule:

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} world!'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
end
```

This generates the exact same text as before, but listing the greeting words on their own is more flexible and eliminates the need to write each variation of the phrase out in full.

This process of starting with a larger fragment of text and breaking it up into smaller phrases and single words is something you’ll do a lot when writing larger and more detailed grammars.

## Using nesting to shape the text

Rules can be arbitrarily nested and connected to generate larger and more complex texts. The way the rules branch out is going to define the shape and ‘flavor’ of the text.

For example, to create more exaggerated variations of the phrase, we can branch out to pick from a list of happy adjectives or a list of sad adjectives:

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} {world_phrase}.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo'
  world_phrase '{happy_adj} world', '{sad_adj} world', 'world'
  happy_adj 'wonderful', 'amazing', 'bright', 'beautiful'
  sad_adj 'cruel', 'miserable'
end
```

Nesting and branching can be manipulated to balance consistency with novelty. The exact same text fragments can be combined in a variety of ways to produce strikingly different resulting texts.

The following grammar branches out at the top level, with `happy_phrase` and `sad_phrase` being generated from completely separate trees that don’t overlap:

```ruby
hello = Calyx::Grammar.new do
  start '{happy_phrase} world.', '{sad_phrase} world.'
  happy_phrase '{happy_greeting} {happy_adj}'
  happy_greeting 'Hello', 'Hi', 'Hey', 'Yo'
  happy_adj 'wonderful', 'amazing', 'bright', 'beautiful'
  sad_phrase '{sad_greeting} {sad_adj}'
  sad_greeting 'Goodbye', 'So long', 'Farewell'
  sad_adj 'cruel', 'miserable'
end
```

Whereas this variation of the grammar uses the same content but generates everything from a single branch, resulting in a word salad with happy and sad fragments mashed together:

```ruby
hello = Calyx::Grammar.new do
  start '{greeting} {adj} world.'
  greeting 'Hello', 'Hi', 'Hey', 'Yo', 'Goodbye', 'So long', 'Farewell'
  adj 'wonderful', 'amazing', 'bright', 'beautiful', 'cruel', 'miserable'
end
```

That’s really all you need to know to get started.
