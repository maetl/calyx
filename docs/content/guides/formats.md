---
layout: default
title: File Formats
permalink: /guides/formats
---

# File Formats

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
