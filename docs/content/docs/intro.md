---
layout: docs
title: Introduction
permalink: /docs/intro/
---

## What is Calyx?

Calyx is a tool for making writing machines using generative grammars.



producing intricate sequences of text

While primarily designed for weird writing, bots and ,

## Theory

Traditional generative grammars are often described as recognizers. Given a particular string as input, the grammar defines whether or not that string is valid in the language accepted by the grammar.

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

It’s pr

- What is Calyx
- Why?
- What kinds of things can it be used for?
