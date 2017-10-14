---
layout: docs
title: Features documented in README
---

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

## The start symbol

By convention, the `start` rule specifies the default starting point for generating the final text. You can start from any other named rule by passing it explicitly to the generate method.

```ruby
class HelloWorld < Calyx::Grammar
  hello 'Hello world!'
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
