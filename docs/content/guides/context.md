---
layout: page
title: Context
permalink: /guides/context
---

j,jnnnnnnjjj

## Constructing rules

To achieve particular effects, structured repetition of grammar rules can be extremely useful, but these sets of rules can be boring and error-prone to write by hand.

```ruby
row "{point}{point}{point}{point}{point}{point}{point}{point}{point}{point}{point}{point}"
```

An easier

```ruby
row (0..12).map { "{point}" }.join
```

## Injecting rules

Sometimes it’s useful to calculate template expansions outside of Calyx and inject them where they’re needed, rather than rely on the hard-coded rules defined in grammar classes and object instances.

The `#generate` method accepts an optional context map parameter which can be used to dynamically combine rules with an existing grammar during the generation process. This feature is generally used like a traditional template engine to substitute individual values that aren’t known ahead of time.

The context map is a hash, with the keys being symbols defining the rules and the values being template expansion strings.

The following example demonstrates how a field returned from a database query could be injected into a grammar to produce a randomized welcome message for users of an app.

```ruby
greeting = Calyx::Grammar.new do
  start 'Hi {username}', 'Welcome back {username}', 'Hola {username}'
end

user = User.find(id: user_id)

context = {
  username: user.name
}

greeting.generate(context)
```
