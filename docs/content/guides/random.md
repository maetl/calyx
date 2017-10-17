---
layout: default
title: Random Sampling
permalink: /guides/random/
---

# Random Sampling

By default, the outcomes of generated rules are selected with Ruby’s built-in pseudorandom number generator (as seen in methods like `Kernel.rand` and `Array.sample`). To seed the random number generator, pass in an integer seed value as the first argument to the constructor:

```ruby
grammar = Calyx::Grammar.new(seed: 12345) do
  # rules...
end
```

Alternatively, you can pass a preconfigured instance of Ruby’s stdlib `Random` class:

```ruby
random = Random.new(12345)

grammar = Calyx::Grammar.new(rng: random) do
  # rules...
end
```

When a random seed isn’t supplied, `Time.new.to_i` is used as the default seed, which makes each run of the generator relatively unique.

## Weighted Choices

Choices can be weighted so that some rules have a greater probability of expanding than others.

Weights are defined by passing a hash instead of a list of rules where the keys are strings or symbols representing the grammar rules and the values are weights.

Weights can be represented as floats, integers or ranges.

- Floats must be in the interval 0..1 and the given weights for a production must sum to 1.
- Ranges must be contiguous and cover the entire interval from 1 to the maximum value of the largest range.
- Integers (Fixnums) will produce a distribution based on the sum of all given numbers, with each number being a fraction of that sum.

The following definitions produce an equivalent weighting of choices:

```ruby
Calyx::Grammar.new do
  start 'heads' => 1, 'tails' => 1
end

Calyx::Grammar.new do
  start 'heads' => 0.5, 'tails' => 0.5
end

Calyx::Grammar.new do
  start 'heads' => 1..5, 'tails' => 6..10
end

Calyx::Grammar.new do
  start 'heads' => 50, 'tails' => 50
end
```

There’s a lot of interesting things you can do with this. For example, you can model the triangular distribution produced by rolling 2d6:

```ruby
Calyx::Grammar.new do
  start(
    '2' => 1,
    '3' => 2,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 5,
    '9' => 4,
    '10' => 3,
    '11' => 2,
    '12' => 1
  )
end
```

Or reproduce Gary Gygax’s famous generation table from the original [Dungeon Master’s Guide](https://en.wikipedia.org/wiki/Dungeon_Master%27s_Guide#Advanced_Dungeons_.26_Dragons) (page 171):

```ruby
Calyx::Grammar.new do
  start(
    :empty => 0.6,
    :monster => 0.1,
    :monster_treasure => 0.15,
    :special => 0.05,
    :trick_trap => 0.05,
    :treasure => 0.05
  )
  empty 'Empty'
  monster 'Monster Only'
  monster_treasure 'Monster and Treasure'
  special 'Special'
  trick_trap 'Trick/Trap.'
  treasure 'Treasure'
end
```
