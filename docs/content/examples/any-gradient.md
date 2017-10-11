---
layout: default
title: Examples
layout: page
permalink: /examples/any-gradient
---

# Examples

The best way to get started quickly is to install the gem and run the examples locally.

## Any Gradient

Requires Roda and Rack to be available.

```
gem install roda
```

Demonstrates how to use Calyx to construct SVG graphics. **Any Gradient** generates a rectangle with a linear gradient of random colours.

Run as a web server and preview the output in a browser (`http://localhost:9292`):

```
ruby examples/any_gradient.rb
```

Or generate SVG files via a command line pipe:

```
ruby examples/any_gradient > gradient1.xml
```
