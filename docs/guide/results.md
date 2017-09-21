# Results

## Accessing the Raw Generated Tree

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
