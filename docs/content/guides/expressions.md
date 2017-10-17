---
layout: page
title: Template Expressions
permalink: /guides/expressions
---

# Template Expressions

Dot-notation is supported in template expressions, allowing you to call any available method on the `String` object returned from a rule. Formatting methods can be chained arbitrarily and will execute in the same way as they would in native Ruby code.

```ruby
greeting = Calyx::Grammar.new do
  start '{hello.capitalize} there.', 'Why, {hello} there.'
  hello 'hello', 'hi'
end

4.times { greeting.generate }
# => "Hello there."
# => "Hi there."
# => "Why, hello there."
# => "Why, hi there."
```

You can also extend the grammar with custom modifiers that provide useful formatting functions.

### Filters

Filters accept an input string and return the transformed output:

```ruby
greeting = Calyx::Grammar.new do
  filter :shoutycaps do |input|
    input.upcase
  end

  start '{hello.shoutycaps} there.', 'Why, {hello.shoutycaps} there.'
  hello 'hello', 'hi'
end

4.times { greeting.generate }
# => "HELLO there."
# => "HI there."
# => "Why, HELLO there."
# => "Why, HI there."
```

### Mappings

The mapping shortcut allows you to specify a map of regex patterns pointing to their resulting substitution strings:

```ruby
green_bottle = Calyx::Grammar.new do
  mapping :pluralize, /(.+)/ => '\\1s'
  start 'One green {bottle}.', 'Two green {bottle.pluralize}.'
  bottle 'bottle'
end

2.times { green_bottle.generate }
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

hello = Calyx::Grammar.new do
  modifier FullStop
  start '{hello.capitalize.full_stop}'
  hello 'hello'
end

hello.generate
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

noun_articles = Calyx::Grammar.new do
  start '{fruit.with_indefinite_article.capitalize.full_stop}'
  fruit 'apple', 'orange', 'banana', 'pear'
end

4.times { noun_articles.generate }
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
