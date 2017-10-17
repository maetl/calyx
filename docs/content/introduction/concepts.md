---
title: Key Concepts
layout: docs
permalink: /introduction/concepts/
---

## What are grammars?

A grammar is a set of interconnected rules that describe the syntax of a language. The grammar rules describe how to form strings in that language based on an alphabet.

## A dash of theory

Traditionally, generative grammars are often described as recognizers. Given a particular string as input, the grammar defines whether or not that string is recognized.

For example, let’s imagine what a pseudocode grammar representing whole numbers greater than zero might look like.

```
start := leading_digit *digit
leading_digit := 1..9
digit := 0..9
```

If we could turn this pseudocode grammar into a recognizer function and run it on a range of possible strings, we’d see the following results.

```ruby
grammar.parse("1")      # => true
grammar.parse("2")      # => true
grammar.parse("99")     # => true
grammar.parse("111")    # => true
grammar.parse("134534") # => true
grammar.parse("0")      # => false
grammar.parse("055")    # => false
grammar.parse("abc")    # => false
grammar.parse("1.5")    # => false
```

How does it work?

The grammar here is made up of ‘production rules’, which in turn are made up of named symbols called ‘nonterminals’ and literal patterns called ‘terminals’ which match a range of possible strings.

In this case, `start`, `leading_digit` and `digit` are nonterminals whereas `1..9` and `0..9` are terminals. By convention, `*` means ‘zero or more’, which specifies that the production can match repeating characters over and over until an unmatched character is found (formally, this is known as the [Kleene star](https://en.wikipedia.org/wiki/Kleene_star)).

To recognize a string with the grammar, we start with a left hand side nonterminal (by convention, this is known as the start symbol, often named `start`) and substitute it with its right hand side production. We then do the same for the next set of nonterminals we find in the production, until we bottom out at a set of terminals matching the literal string.

If we walk through

```
grammar.parse("1")
```

1. Replace `start` with `leading_digit` then `*digit`
2. `leading_digit` is a terminal `1..9`, so check that the first character matches
3. `*digit`



If you’re familiar with regular expressions, you’ll notice that this grammar seems to do exactly the same thing as the following regular expression.

```ruby
/^[1-9][0-9]*$/
```

Remarkably, this isn’t a coincidence or example of TMTOWTDI. It turns out that there’s a deep symmetry between grammars and regular expressions. Every regular grammar can be transformed into an equivalent regular expression and vice versa.

```
Number := Zero | Integer | Decimal | Real
Integer := LeadingDigit *Digit
LeadingDigit := [1-9]
Digit := [0-9]
Decimal := Integer "." *Digit
Real := Integer "/" Integer
Zero := "0"
```

The following sequences are recognised as valid by the number grammar:

- `1`
- `23.424`
- `30000`
- `1/7`

Template expansion grammars
